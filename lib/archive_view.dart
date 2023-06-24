import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:keepnotes/create_note_view.dart';
import 'package:keepnotes/note_view.dart';
import 'package:keepnotes/search_page.dart';
import 'package:keepnotes/services/db.dart';
import 'package:keepnotes/side_menu_bar.dart';
import 'package:keepnotes/model/note_model.dart';
import 'package:keepnotes/colors.dart';

class ArchiveView extends StatefulWidget {
  const ArchiveView({Key? key}) : super(key: key);

  @override
  _ArchiveViewState createState() => _ArchiveViewState();
}

class _ArchiveViewState extends State<ArchiveView> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  late List<Note> notesList;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getAllNotes();
  }

  Future getAllNotes() async {
    notesList = await NotesDatabase.instance.readAllArchiveNotes();
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  String note1 = 'First Note';
  String note2 = 'Second Note';
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Scaffold(
            backgroundColor: bgColor,
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          )
        : Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateNoteView(),
                  ),
                );
              },
              backgroundColor: cardColor,
              child: const Icon(
                Icons.add,
                size: 45,
              ),
            ),
            endDrawerEnableOpenDragGesture: true,
            key: _drawerKey,
            drawer: const SideMenu(),
            backgroundColor: bgColor,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      width: MediaQuery.of(context).size.width,
                      height: 55,
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 3,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.arrow_back_sharp,
                                  color: white,
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const SearchView(),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 55,
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Search Your Notes',
                                        style: TextStyle(
                                            color: white.withOpacity(0.5),
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: const Row(
                              children: [
                                // TextButton(
                                //     style: ButtonStyle(
                                //         overlayColor:
                                //         MaterialStateColor.resolveWith(
                                //                 (states) =>
                                //                 white.withOpacity(0.1)),
                                //         shape: MaterialStateProperty.all<
                                //             RoundedRectangleBorder>(
                                //             RoundedRectangleBorder(
                                //               borderRadius:
                                //               BorderRadius.circular(50.0),
                                //             ))),
                                //     onPressed: () {},
                                //     child: const Icon(
                                //       Icons.grid_view,
                                //       color: white,
                                //     )),
                                // const SizedBox(
                                //   width: 9,
                                // ),
                                // const CircleAvatar(
                                //   radius: 16,
                                //   backgroundColor: Colors.white,
                                // )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    noteSectionAll(),
                    // notesListSection()
                  ],
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
                'All',
                style: TextStyle(
                  color: white.withOpacity(0.5),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
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
            itemCount: notesList.length,
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
                      note: notesList[index],
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
                      notesList[index].title,
                      style: const TextStyle(
                        color: white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      notesList[index].content.length > 250
                          ? '${notesList[index].content.substring(0, 250)}...'
                          : notesList[index].content,
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

  Widget notesListSection() {
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
                'List View',
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
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 10,
            itemBuilder: (context, index) => Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: white.withOpacity(0.4),
                ),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Heading',
                    style: TextStyle(
                        color: white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    index.isEven
                        ? note1.length > 250
                            ? '${note1.substring(0, 250)}...'
                            : note1
                        : note2,
                    style: const TextStyle(color: white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
