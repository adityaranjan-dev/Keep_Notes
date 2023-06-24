import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:keepnotes/colors.dart';
import 'package:keepnotes/services/db.dart';
import 'package:keepnotes/note_view.dart';
import 'package:keepnotes/model/note_model.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  List<int> searchResultIDs = [];
  List<Note?> searchResultNotes = [];
  bool isLoading = false;

  void searchResults(String query) async {
    searchResultNotes.clear();
    setState(() {
      isLoading = true;
    });
    final resultIds = await NotesDatabase.instance.getNoteString(query);
    List<Note?> searchResultNotesLocal = [];
    resultIds.forEach((element) async {
      final searchNote = await NotesDatabase.instance.readOneNote(element);
      searchResultNotesLocal.add(searchNote);
      setState(() {
        searchResultNotes.add(searchNote);
      });
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: white.withOpacity(0.1),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_outlined),
                      color: white,
                    ),
                    Expanded(
                      child: TextField(
                        textInputAction: TextInputAction.search,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: 'Search Your Notes',
                          hintStyle: TextStyle(
                            color: white.withOpacity(0.5),
                            fontSize: 16,
                          ),
                        ),
                        onSubmitted: (value) {
                          setState(() {
                            searchResults(
                              value.toLowerCase(),
                            );
                          });
                        },
                      ),
                    ),
                  ],
                ),
                isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : noteSectionAll(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget noteSectionAll() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Search Results',
                style: TextStyle(
                    color: white.withOpacity(0.5),
                    fontSize: 13,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 15,
          ),
          child: StaggeredGridView.countBuilder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: searchResultNotes.length,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            crossAxisCount: 4,
            staggeredTileBuilder: (index) => const StaggeredTile.fit(2),
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NoteView(
                      note: searchResultNotes[index],
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: white.withOpacity(0.4),
                  ),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      searchResultNotes[index]!.title,
                      style: const TextStyle(
                          color: white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      searchResultNotes[index]!.content.length > 250
                          ? '${searchResultNotes[index]!.content.substring(0, 250)}...'
                          : searchResultNotes[index]!.content,
                      style: const TextStyle(color: white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
