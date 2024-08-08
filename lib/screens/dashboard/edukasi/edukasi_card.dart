import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kjm_app/constants.dart';
import 'package:kjm_app/model/article.dart';
import 'package:kjm_app/screens/dashboard/edukasi/artikel_detail_page.dart';
import 'package:kjm_app/utils/image_loader.dart';

class EdukasiCard extends StatelessWidget {
  const EdukasiCard({
    super.key,
    required this.article,
  });

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(4.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ArtikelDetailPage(article: article),
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildImageFromUrl(
                      '${ApiConstants.apiUrl}/article/image/${article.uuid}',
                      40.0),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        article.articleType.name,
                        style: const TextStyle(
                          color: Color(0xFFD3A029),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        article.title.length > 18
                            ? '${article.title.substring(0, 18)}...'
                            : article.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        '${DateFormat('dd MMM yyyy').format(article.createdAt.toLocal())} Pukul ${DateFormat('hh:mm:ss a').format(article.createdAt.toLocal())}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
