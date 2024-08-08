import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kjm_app/blocs/edukasi/edukasi_bloc.dart';
import 'package:kjm_app/blocs/edukasi/edukasi_event.dart';
import 'package:kjm_app/blocs/edukasi/edukasi_state.dart';
import 'package:kjm_app/screens/dashboard/edukasi/edukasi_card.dart';

class EdukasiPage extends StatelessWidget {
  EdukasiPage({super.key});
  final TextEditingController _filterController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pojok Edukasi",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _filterController,
              onChanged: (text) {
                context.read<EdukasiBloc>().add(FilterArticles(text));
              },
              decoration: InputDecoration(
                labelText: "Cari",
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                filled: true, // Enables the background color fill
                fillColor: Colors.white,
                prefixIcon: const Icon(
                  Icons.search,
                  size: 25,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    _filterController.clear();
                    context
                        .read<EdukasiBloc>()
                        .add(FilterArticles(_filterController.text));
                    //filterArticle(searchController.text);
                  },
                  icon: const Icon(Icons.delete_forever_rounded),
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<EdukasiBloc, EdukasiState>(
              builder: (context, state) {
                if (state is EdukasiInitial) {
                  context.read<EdukasiBloc>().add(FetchArticles());
                  return const Center(child: CircularProgressIndicator());
                } else if (state is EdukasiLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is EdukasiLoaded) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<EdukasiBloc>().add(FetchArticles());
                    },
                    child: ListView.builder(
                      itemCount: state.filteredArticles.length,
                      itemBuilder: (context, index) {
                        final article = state.filteredArticles[index];
                        return EdukasiCard(article: article);
                      },
                    ),
                  );
                } else if (state is EdukasiError) {
                  return Center(child: Text('Error: ${state.message}'));
                } else {
                  return const Center(child: Text('Unknown state'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
