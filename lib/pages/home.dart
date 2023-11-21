import 'package:chat_wamz/pages/chatpage.dart';
import 'package:chat_wamz/service/database.dart';
import 'package:chat_wamz/service/shared_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iconsax/iconsax.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool search = false;

  String? myName, myProfilePic, myUserName, myEmail;
  Stream? chatRoomsStream;

  getthesharedpref() async {
    myName = await SharedPreferenceHelper().getDisplayName();
    myEmail = await SharedPreferenceHelper().getUserEmail();
    myProfilePic = await SharedPreferenceHelper().getUserPic();
    myUserName = await SharedPreferenceHelper().getUserName();
    setState(() {

    });
  }
  ontheload() async{
    await getthesharedpref();
    chatRoomsStream = await DatabaseMethods().getChatRooms();
    setState(() {

    });
  }

  Widget ChatRoomList(){
    return StreamBuilder(
        stream: chatRoomsStream,
        builder: (context, AsyncSnapshot snapshot){
          return snapshot.hasData? ListView.builder(
            padding: EdgeInsets.zero,
              itemCount: snapshot.data.docs.length,
              shrinkWrap: true,
              itemBuilder: (context, index){
              DocumentSnapshot ds = snapshot.data.docs[index];
              return ChatRoomListTile(chatRoomId: ds.id, lastMessage: ds["lastMessage"], myUsername: myUserName!, time: ds["lastMessageSendTs"]);
              }
          ):
          Center(
            child: CircularProgressIndicator(),
          );
        }
    );
  }

  @override
  void initState(){
    super.initState();
    ontheload();
  }

  getChatRoomIdbyUsername(String a, String b){
    if(a.substring(0,1).codeUnitAt(0) > b.substring(0,1).codeUnitAt(0)){
      return '${b}_$a';
    }
    else{
      return '${a}_$b';
    }
  }

  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(value){
    if(value.length == 0){
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
  }
    setState(() {
      search = true;
    });
    var capitalizedValue = value.substring(0,1).toUpperCase()+value.substring(1);
    if(queryResultSet.isEmpty && value.length == 1){
      DatabaseMethods().Search(value).then((QuerySnapshot docs){
        for (int i=0; i<docs.docs.length; i++){
          queryResultSet.add(docs.docs[i].data());
        }
      });
    }
    else {
      tempSearchStore = [];
      for (var element in queryResultSet) {
        if(element['Username'].startsWith(capitalizedValue)){
          setState(() {
            tempSearchStore.add(element);
          });
        }
      }
    }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: SingleChildScrollView(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Row has child Text and Search Icon Inside a column
                /// Text
                search? Expanded(
                  child: TextField(
                    onChanged: (value) {
                      initiateSearch(value.toUpperCase());
                    },
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search',
                      hintStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                ) : Text("ChatWamz", style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Amarillo',
                ),
                ),

                /// Search Icon
                GestureDetector(
                  onTap: (){
                    search = true;
                    setState(() {

                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        // color: Colors.black26,
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: search? GestureDetector(
                      onTap: (){
                        setState(() {
                          search = false;
                        });
                      },
                      child: Icon(
                        Iconsax.close_circle5,
                        size: 30,
                        color: Colors.white,
                      ),
                    ):
                    Icon(
                      Iconsax.search_normal,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
          /// Container for chats.
          Container(
            padding: EdgeInsets.only(top: 10),
            height: search? MediaQuery.of(context).size.height/1.12 : MediaQuery.of(context).size.height/1.12,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              children: [
                search? ListView(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  primary: false,
                  shrinkWrap: true,
                  children: tempSearchStore.map((element){
                      return buildResultCard(element);
                    }).toList()

                ):
                ChatRoomList(),
              ],
            ),
          )
        ],
      )
      ),
    );
  }
  Widget buildResultCard (data)   {
    return GestureDetector(
      onTap: () async {
        search = false;
        setState(() {

        });
        var chatRoomId = getChatRoomIdbyUsername(myUserName!, data['Username']);
        Map<String, dynamic>chatRoomInfoMap={
          'Users' : [myUserName, data['Username']],
        };
        await DatabaseMethods().createChatRoom(chatRoomId, chatRoomInfoMap);
        // ignore: use_build_context_synchronously
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(
          name: data['Name'],
          profileurl: data['Photo'],
          username: data['Username'],)
        )
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white70,
            ),
            child: Row(
              children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                      backgroundImage: NetworkImage(data['Photo'])
                  ),
                ],
              ),
                SizedBox(width: 20,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data['Name'], style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 27
                    ),
                    ),
                    SizedBox(height: 5,),
                    Text(data['Username'], style: TextStyle(
                            fontSize: 15
                        ),
                        ),
                      ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



final currentTime = DateTime.now();
final formattedTime = DateFormat('h:mm a').format(currentTime);

// var arrNames = ['Susan Mam', 'Ramika Sen', 'Daddy Speed', ''];
// var randomNames = RandomNames(Zone.zimbabwe);

class ChatRoomListTile extends StatefulWidget {
  final String lastMessage, chatRoomId, myUsername, time;
  const ChatRoomListTile({super.key, required this.chatRoomId, required this.lastMessage, required this.myUsername, required this.time});

  @override
  State<ChatRoomListTile> createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {
  String profilePicUrl = "", name = "", username = "", id = "";

  getthisUserInfo() async {
    username = widget.chatRoomId.replaceAll("_", "").replaceAll(widget.myUsername, "");
    QuerySnapshot querySnapshot =  await DatabaseMethods().getUserInfo(username.toUpperCase());
    name = "${querySnapshot.docs[0]["Name"]}";
    profilePicUrl = "${querySnapshot.docs[0]["Photo"]}";
    username = "${querySnapshot.docs[0]["Username"]}";
    // id = "${querySnapshot.docs[0]["Id"]}";
    id = querySnapshot.docs[0].id;
    setState(() {

    });
  }

  @override
  void initState() {
    getthisUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(name: name, profileurl: profilePicUrl, username: username)));
        },
        child: ListTile(

          leading: profilePicUrl == ""? CircularProgressIndicator() : CircleAvatar(
            radius: 30,
            backgroundColor: Colors.red,
            backgroundImage: NetworkImage(profilePicUrl),
          ),
          title: Text(name, style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18
          ),
          ),
          subtitle: Text(widget.lastMessage,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
            color: Colors.black87,
          ),
          ),

          trailing: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(widget.time, style: TextStyle(
                fontSize: 11,
                color: Colors.black87
            ),),
          ),
        ),
      ),
    );
  }
}
