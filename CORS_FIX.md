# Correction des Erreurs CORS et Redirections HTTPS

## Problème Original
```
Access to XMLHttpRequest at 'http://collecte-taxe.onrender.com/api/collectes/'
(redirected from 'https://collecte-taxe.onrender.com/api/collectes')
from origin 'http://localhost:4200' has been blocked by CORS policy:
Response to preflight request doesn't pass access control check:
Redirect is not allowed for a preflight request.
```

**Cause** : Render redirige HTTP → HTTPS, mais les requêtes CORS preflight (OPTIONS) ne supportent pas les redirections.

---

## Solutions Implémentées

### 1️⃣ **Frontend - Forcer HTTPS**

**Fichier** : `frontend/frontend/src/environments/environment.ts`
```typescript
export const environment = {
  production: false,
  apiUrl: 'https://collecte-taxe.onrender.com/api'  // ✅ HTTPS seulement
};
```

### 2️⃣ **Frontend - Interceptor CORS Amélioré**

**Fichier** : `frontend/frontend/src/app/services/api.service.ts`

```typescript
export class CorsInterceptor implements HttpInterceptor {
  intercept(req: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
    // ✅ Forcer HTTPS pour les requêtes vers Render
    let modifiedUrl = req.url;
    if (req.url.includes('collecte-taxe.onrender.com') && req.url.startsWith('http://')) {
      modifiedUrl = req.url.replace('http://', 'https://');
      console.log(`[CORS] 🔒 Forcing HTTPS: ${req.url} -> ${modifiedUrl}`);
    }

    const modifiedReq = req.clone({
      url: modifiedUrl,
      setHeaders: {
        'Cache-Control': 'no-cache, no-store, must-revalidate',
        'Pragma': 'no-cache'
      }
    });
    
    return next.handle(modifiedReq).pipe(
      tap(event => {
        if (event instanceof HttpResponse) {
          console.log(`[CORS] ✅ Success: ${req.method} ${modifiedUrl} -> ${event.status}`);
        }
      }),
      catchError((error: HttpErrorResponse) => {
        if (error.status === 0) {
          // ✅ Retry avec HTTPS strict
          const retryUrl = modifiedUrl.replace('http://', 'https://');
          const retryReq = req.clone({
            url: retryUrl,
            setHeaders: {
              'Accept': 'application/json',
              'Cache-Control': 'no-cache, no-store, must-revalidate'
            }
          });
          return next.handle(retryReq);
        }
        return throwError(() => error);
      })
    );
  }
}
```

### 3️⃣ **Backend - Configuration CORS Améliorée**

**Fichier** : `backend/main.py`

```python
import os

# ✅ Configuration CORS robuste pour Render
cors_origins_env = os.getenv("CORS_ORIGINS", "http://localhost:4200,http://127.0.0.1:4200,https://localhost:4200")
cors_origins = [origin.strip() for origin in cors_origins_env.split(",") if origin.strip()]

# ✅ En production sur Render, ajouter les domaines Render
if os.getenv("ENVIRONMENT") == "production" or os.getenv("RENDER") == "true":
    cors_origins.extend([
        "https://collecte-taxe.onrender.com",
        "http://collecte-taxe.onrender.com"
    ])

# ✅ Supprimer les doublons
cors_origins = list(set(cors_origins))

app.add_middleware(
    CORSMiddleware,
    allow_origins=cors_origins,
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
    allow_headers=["*"],
    max_age=3600  # ✅ Cache preflight requests for 1 hour
)
```

### 4️⃣ **Backend - Middleware pour Gérer les Préflights**

**Fichier** : `backend/main.py`

```python
# ✅ Middleware pour ajouter les headers de sécurité et gérer les préflights CORS
@app.middleware("http")
async def handle_preflight(request: Request, call_next):
    # ✅ Répondre directement aux requêtes OPTIONS (preflight)
    if request.method == "OPTIONS":
        return Response(
            status_code=200,
            headers={
                "Access-Control-Allow-Origin": request.headers.get("origin", "*"),
                "Access-Control-Allow-Methods": "GET, POST, PUT, PATCH, DELETE, OPTIONS",
                "Access-Control-Allow-Headers": request.headers.get("access-control-request-headers", "*"),
                "Access-Control-Max-Age": "3600",
                "Access-Control-Allow-Credentials": "true"
            }
        )
    response = await call_next(request)
    return response
```

### 5️⃣ **Render Configuration**

**Fichier** : `backend/render.yaml`

```yaml
services:
  - type: web
    name: e-taxe-api
    startCommand: uvicorn main:app --host 0.0.0.0 --port $PORT --proxy-headers
    envVars:
      - key: ENVIRONMENT
        value: production
      - key: RENDER
        value: "true"  # ✅ Flag pour détecter l'environnement Render
      - key: CORS_ORIGINS
        value: https://localhost:4200,http://localhost:4200,https://collecte-taxe.onrender.com,http://collecte-taxe.onrender.com
```

---

## Points Clés

✅ **HTTPS Obligatoire** - Toutes les requêtes utilisent HTTPS seulement
✅ **Interceptor Robuste** - Convertit HTTP → HTTPS automatiquement + retry
✅ **CORS Complet** - Liste blanche incluant Render et localhost
✅ **Middleware Preflight** - Répond aux requêtes OPTIONS sans redirection
✅ **Max-Age Preflight** - Cache les requêtes preflight 1 heure pour réduire les appels

---

## Déploiement sur Render

1. Assurer que les variables d'environnement sont configurées :
   ```
   ENVIRONMENT=production
   RENDER=true
   CORS_ORIGINS=https://localhost:4200,http://localhost:4200,https://collecte-taxe.onrender.com,http://collecte-taxe.onrender.com
   ```

2. Redéployer le backend avec :
   ```bash
   git push  # Ou redéployer manuellement depuis Render
   ```

3. Vérifier que le frontend envoie les requêtes en HTTPS

---

## Tests

### Test Local
```bash
# Backend
uvicorn main:app --host 0.0.0.0 --port 8000

# Frontend
ng serve
```

Ouvrir à : `https://localhost:4200` (note le HTTPS)

### Test Production
Requête HTTPS vers Render:
```bash
curl -X GET https://collecte-taxe.onrender.com/api/collectes/
```

---

## Ressources
- [CORS Policy MDN](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS)
- [FastAPI CORS Documentation](https://fastapi.tiangolo.com/tutorial/cors/)
- [Render Documentation](https://render.com/docs/)
