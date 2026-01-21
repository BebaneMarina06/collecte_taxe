export interface AppareilCollecteur {
  id: number;
  collecteur_id: number;
  device_id: string;
  plateforme?: string;
  device_info?: any;
  authorized: boolean;
  created_at: string;
  updated_at: string;
}

