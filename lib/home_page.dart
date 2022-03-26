// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'colors.dart' as color;
import 'my_sqflite.dart';
import 'video_info.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _journals = [];
  bool _isLoading = true;

  void _refreshJournals() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }

  void initState() {
    super.initState();
    _refreshJournals();
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingJournal =
          _journals.firstWhere((element) => element['id'] == id);
      _titleController.text = existingJournal['title'];
      _descriptionController.text = existingJournal['img_1'];
    }
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        elevation: 5,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                  left: 15,
                  top: 15,
                  right: 15,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration:
                          InputDecoration(hintText: 'Enter the text title'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _descriptionController,
                      decoration:
                          InputDecoration(hintText: 'Enter the image link'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        // Save new journal
                        if (id == null) {
                          await _addItem();
                        }

                        if (id != null) {
                          await _updateItem(id);
                        }

                        // Clear the text fields
                        _titleController.text = '';
                        _descriptionController.text = '';

                        // Close the bottom sheet
                        Navigator.of(context).pop();
                      },
                      child: Text(id == null ? 'Create New' : 'Update'),
                    ),
                    SizedBox(height: 20)
                  ],
                ),
              ),
            ));
  }

  // Insert a new journal to the database
  Future<void> _addItem() async {
    await SQLHelper.createItem(
        _titleController.text, _descriptionController.text);
    _refreshJournals();
    Get.snackbar("Insert", "Successfully Insert a journal !",
        snackPosition: SnackPosition.BOTTOM,
        icon: Icon(Icons.face, size: 30, color: Colors.white),
        backgroundColor: color.AppColor.gradientSecond,
        colorText: Colors.white);
  }

  // Update an existing journal
  Future<void> _updateItem(int id) async {
    await SQLHelper.updateItem(
        id, _titleController.text, _descriptionController.text);
    _refreshJournals();
    Get.snackbar("Update", "Successfully Update a journal !",
        snackPosition: SnackPosition.BOTTOM,
        icon: Icon(Icons.face, size: 30, color: Colors.white),
        backgroundColor: color.AppColor.gradientSecond,
        colorText: Colors.white);
  }

  // Delete an item
  void _deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    Get.snackbar("Delete", "Successfully deleted a journal !",
        snackPosition: SnackPosition.BOTTOM,
        icon: Icon(Icons.face, size: 30, color: Colors.white),
        backgroundColor: color.AppColor.gradientSecond,
        colorText: Colors.white);
    _refreshJournals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.AppColor.homePageBackground,
      body: ListView(
        children: [
          Container(
            height: 750,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    // height: 450,  <=== (xpanded)
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // #############################################################################
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Training",
                              style: TextStyle(
                                  fontSize: 30,
                                  color: color.AppColor.homePageTitle,
                                  fontWeight: FontWeight.w700),
                            ),
                            Row(children: [
                              Icon(Icons.arrow_back_ios,
                                  size: 20,
                                  color: color.AppColor.homePageIcons),
                              SizedBox(width: 10),
                              Icon(Icons.calendar_today_outlined,
                                  size: 20,
                                  color: color.AppColor.homePageIcons),
                              SizedBox(width: 15),
                              Icon(Icons.arrow_forward_ios,
                                  size: 20,
                                  color: color.AppColor.homePageIcons),
                            ])
                          ],
                        ),
                        // #############################################################################
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Your program",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: color.AppColor.homePageSubtitle,
                                  fontWeight: FontWeight.w700),
                            ),
                            InkWell(
                              child: Row(
                                children: [
                                  Text(
                                    "Details",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: color.AppColor.homePageDetail),
                                  ),
                                  SizedBox(width: 5),
                                  Icon(Icons.arrow_forward,
                                      size: 20,
                                      color: color.AppColor.homePageIcons)
                                ],
                              ),
                              onTap: () {
                                Get.to(() => VideoInfo());
                              },
                            ),
                          ],
                        ),
                        //  ##############################################################################
                        Container(
                          width: double.infinity,
                          height: 180,
                          padding: EdgeInsets.only(left: 20, right: 20),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    color.AppColor.gradientFirst
                                        .withOpacity(0.8),
                                    color.AppColor.gradientSecond
                                        .withOpacity(0.9)
                                  ],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.centerRight),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(80),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(5, 10),
                                    blurRadius: 20,
                                    color: color.AppColor.gradientSecond
                                        .withOpacity(0.3)),
                              ]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Next workout",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: color
                                        .AppColor.homePageContainerTextSmall),
                              ),
                              Text(
                                "Legs Toning",
                                style: TextStyle(
                                    fontSize: 25,
                                    color: color
                                        .AppColor.homePageContainerTextSmall),
                              ),
                              Text(
                                "and Glutes Workout",
                                style: TextStyle(
                                    fontSize: 25,
                                    color: color
                                        .AppColor.homePageContainerTextSmall),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.timer,
                                          size: 20,
                                          color: color.AppColor
                                              .homePageContainerTextSmall),
                                      SizedBox(width: 10),
                                      Text(
                                        "60 min",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: color.AppColor
                                                .homePageContainerTextSmall),
                                      ),
                                    ],
                                  ),
                                  Container(),
                                  Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(60),
                                          boxShadow: [
                                            BoxShadow(
                                                color: color
                                                    .AppColor.gradientFirst
                                                    .withOpacity(0.8),
                                                blurRadius: 10,
                                                offset: Offset(4, 8))
                                          ]),
                                      child: InkWell(
                                        onTap: () {
                                          Get.to(() => VideoInfo());
                                        },
                                        child: Icon(Icons.play_circle_fill,
                                            color: Colors.white, size: 60),
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                        //  ##############################################################################
                        Container(
                          height: 100,
                          width: double.infinity,
                          child: Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 100,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                        image: AssetImage("assets/card.png"),
                                        fit: BoxFit.fill),
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 40,
                                          offset: Offset(-1, -5),
                                          color: color.AppColor.gradientSecond
                                              .withOpacity(0.3))
                                    ]),
                              ),
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(
                                  right: 200,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                    image: AssetImage("assets/figure.png"),
                                  ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                height: 80,
                                margin: EdgeInsets.only(left: 120),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "You are doing dreat",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: color.AppColor.homePageDetail),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Keep it up",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: color
                                                  .AppColor.homePagePlanColor),
                                        ),
                                        Text(
                                          "Stick to your plan",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: color
                                                  .AppColor.homePagePlanColor),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // ###############################################################################
                        Container(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "Area of foucs",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
                                color: color.AppColor.homePageTitle),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // ################################################################################
                Expanded(
                    flex: 1,
                    child: OverflowBox(
                      maxWidth: MediaQuery.of(context).size.width,
                      child: _isLoading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : ListView.builder(
                              itemCount: (_journals.length),
                              itemBuilder: (context, index) {
                                return Container(
                                  alignment: Alignment.center,
                                  height: 120,
                                  width: double.infinity,
                                  // (MediaQuery.of(context).size.width - 90),
                                  margin: EdgeInsets.fromLTRB(30, 30, 30, 0),
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 3,
                                            offset: Offset(5, 5),
                                            color: color.AppColor.gradientSecond
                                                .withOpacity(0.1)),
                                        BoxShadow(
                                            blurRadius: 3,
                                            offset: Offset(-5, -5),
                                            color: color.AppColor.gradientSecond
                                                .withOpacity(0.1))
                                      ]),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        child: Image(
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                _journals[index]["img_1"])),
                                      ),
                                      Text(
                                        _journals[index]["title"],
                                        style: TextStyle(
                                            fontSize: 20,
                                            color:
                                                color.AppColor.homePageDetail),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.edit,
                                                color: color
                                                    .AppColor.homePageDetail),
                                            onPressed: () => _showForm(
                                                _journals[index]['id']),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete,
                                                color: color
                                                    .AppColor.homePageDetail),
                                            onPressed: () => _deleteItem(
                                                _journals[index]['id']),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }),
                    )),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: color.AppColor.homePageDetail,
        onPressed: () => _showForm(null),
      ),
    );
  }
}
