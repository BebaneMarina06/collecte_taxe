import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:e_taxe/models/collecte.dart';
import 'package:intl/intl.dart';

class ReceiptService {
  static Future<void> generateAndPrintReceipt(Collecte collecte) async {
    try {
      final pdf = await _generatePDF(collecte);
      
      // Afficher le dialogue d'impression
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    } catch (e) {
      throw Exception('Erreur lors de la génération du reçu: $e');
    }
  }

  static Future<void> generateAndShareReceipt(Collecte collecte) async {
    try {
      final pdf = await _generatePDF(collecte);
      
      // Sauvegarder temporairement le PDF
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/receipt_${collecte.id}_${DateTime.now().millisecondsSinceEpoch}.pdf');
      await file.writeAsBytes(await pdf.save());
      
      // Partager le fichier
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Reçu de collecte - ${collecte.reference}',
      );
    } catch (e) {
      throw Exception('Erreur lors du partage du reçu: $e');
    }
  }

  static Future<pw.Document> _generatePDF(Collecte collecte) async {
    final pdf = pw.Document();
    final dateFormat = DateFormat('dd/MM/yyyy à HH:mm', 'fr');
    final numberFormat = NumberFormat.currency(symbol: '', decimalDigits: 0, locale: 'fr');

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // En-tête
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    'MAIRIE DE LIBREVILLE',
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    'REÇU DE COLLECTE DE TAXE',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
              pw.Divider(),
              pw.SizedBox(height: 20),

              // Informations du reçu
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Référence: ${collecte.reference}',
                        style: const pw.TextStyle(fontSize: 12),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text(
                        'Date: ${dateFormat.format(collecte.dateCollecte)}',
                        style: const pw.TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'Statut: ${collecte.statut.toUpperCase()}',
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),

              // Informations du contribuable
              pw.Text(
                'INFORMATIONS DU CONTRIBUABLE',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              if (collecte.contribuable != null) ...[
                _buildInfoRow('Nom', collecte.contribuable!.nom),
                _buildInfoRow('Prénom', collecte.contribuable!.prenom),
                if (collecte.contribuable!.telephone != null)
                  _buildInfoRow('Téléphone', collecte.contribuable!.telephone!),
                if (collecte.contribuable!.adresse != null)
                  _buildInfoRow('Adresse', collecte.contribuable!.adresse!),
              ],
              pw.SizedBox(height: 20),

              // Informations de la collecte
              pw.Text(
                'DÉTAILS DE LA COLLECTE',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              if (collecte.taxe != null)
                _buildInfoRow('Type de taxe', collecte.taxe!.nom),
              _buildInfoRow('Moyen de paiement', _formatPaymentType(collecte.typePaiement)),
              pw.SizedBox(height: 10),

              // Tableau des montants
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          'Montant',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          '${numberFormat.format(collecte.montant)} XAF',
                          textAlign: pw.TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  if (collecte.commission > 0)
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            'Commission',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            '${numberFormat.format(collecte.commission)} XAF',
                            textAlign: pw.TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.grey200,
                    ),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          'TOTAL',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          '${numberFormat.format(collecte.montant + collecte.commission)} XAF',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),

              // Billetage si disponible
              if (collecte.billetage != null && collecte.billetage!.isNotEmpty) ...[
                pw.Text(
                  'BILLETAGE',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  collecte.billetage!,
                  style: const pw.TextStyle(fontSize: 12),
                ),
                pw.SizedBox(height: 20),
              ],

              // Informations du collecteur
              if (collecte.collecteur != null) ...[
                pw.Divider(),
                pw.SizedBox(height: 10),
                pw.Text(
                  'Collecteur: ${collecte.collecteur!.fullName}',
                  style: const pw.TextStyle(fontSize: 10),
                ),
                pw.Text(
                  'Matricule: ${collecte.collecteur!.matricule}',
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ],

              pw.Spacer(),

              // Pied de page
              pw.Divider(),
              pw.SizedBox(height: 10),
              pw.Text(
                'Ce document est généré automatiquement et certifie le paiement de la taxe.',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontStyle: pw.FontStyle.italic,
                ),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                'Merci de votre contribution !',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontStyle: pw.FontStyle.italic,
                ),
                textAlign: pw.TextAlign.center,
              ),
            ],
          );
        },
      ),
    );

    return pdf;
  }

  static pw.Widget _buildInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 5),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 100,
            child: pw.Text(
              '$label:',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Expanded(
            child: pw.Text(value),
          ),
        ],
      ),
    );
  }

  static String _formatPaymentType(String type) {
    switch (type.toLowerCase()) {
      case 'cash':
        return 'Espèces';
      case 'mobile_money':
        return 'Mobile Money';
      case 'bamboo':
        return 'Bamboo';
      case 'carte':
        return 'Carte bancaire';
      default:
        return type;
    }
  }
}

