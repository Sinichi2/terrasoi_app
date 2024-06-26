import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Messaging App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MessagingPage(),
    );
  }
}

class MessagingPage extends StatefulWidget {
  const MessagingPage({Key? key}) : super(key: key);

  @override
  State<MessagingPage> createState() => _MessagingPageState();
}

class _MessagingPageState extends State<MessagingPage> {
  final List<ChatItem> _chats = [
    ChatItem(
      username: 'miggyboi',
      messages: [
        Message(
            sender: 'miggyboi',
            text:
                'Hi there, are you available around 4PM today for meeting with a new client?',
            time: '10:45 AM'),
        Message(sender: 'me', text: 'Hey, miggyboi', time: '10:46 AM'),
        Message(
            sender: 'me', text: 'Sure, just give me a call!', time: '10:46 AM'),
        Message(
            sender: 'miggyboi', text: 'Great, see you then!', time: '10:48 AM'),
        Message(
            sender: 'miggyboi',
            text: 'Don’t forget to bring the documents.',
            time: '10:49 AM'),
      ],
    ),
    ChatItem(
      username: 'JoddGwapo',
      messages: [
        Message(
            sender: 'JoddGwapo',
            text: 'Are we still on for tomorrow?',
            time: 'Yesterday'),
        Message(sender: 'me', text: 'Yes, same time!', time: 'Yesterday'),
        Message(
            sender: 'JoddGwapo',
            text: 'Awesome, Im looking good!',
            time: 'Yesterday'),
      ],
    ),
    ChatItem(
      username: 'Shiva',
      messages: [
        Message(
            sender: 'Shiva',
            text: 'I need help with the project.',
            time: 'Last week'),
        Message(
            sender: 'me',
            text: 'What part are you stuck on?',
            time: 'Last week'),
        Message(
            sender: 'Shiva',
            text: 'The design phase is confusing me.',
            time: 'Last week'),
        Message(
            sender: 'me',
            text: 'Let’s schedule a meeting to discuss this.',
            time: 'Last week'),
        Message(
            sender: 'Shiva',
            text: 'Thank you, that would be helpful.',
            time: 'Last week'),
      ],
    ),
  ];

  void _deleteChat(int index) {
    setState(() {
      _chats.removeAt(index);
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Chat deleted')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // DISABLED FOR NOW :3
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,  // Removes the default back button
      //   actions: [
      //     IconButton(
      //       icon: Icon(Icons.add, size: 30),
      //       onPressed: () {
      //         // Implement adding new chat functionality
      //       },
      //       tooltip: 'Add new chat',  // Optional: Adds a tooltip for accessibility
      //     ),
      //   ],
      //   elevation: 0,  // Optional: Removes shadow from the AppBar
      // ),
      body: ListView.builder(
        itemCount: _chats.length,
        itemBuilder: (context, index) {
          final item = _chats[index];
          return Dismissible(
            key: Key(item.username),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              _deleteChat(index);
            },
            background: Container(
              color: Colors.red,
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.centerRight,
              child: Icon(Icons.delete, color: Colors.white),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage:
                    NetworkImage('https://via.placeholder.com/150'),
                radius: 24,
              ),
              title: Text(item.username),
              subtitle: Text(item.messages.last.text),
              // Display the last message
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChatDetailsPage(chatItem: item)));
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.green,
        child: Icon(Icons.add, color: Colors.white,size: 35,),
      ),
    );
  }
}

class ChatDetailsPage extends StatefulWidget {
  final ChatItem chatItem;

  ChatDetailsPage({Key? key, required this.chatItem}) : super(key: key);

  @override
  _ChatDetailsPageState createState() => _ChatDetailsPageState();
}

class _ChatDetailsPageState extends State<ChatDetailsPage> {
  TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    String text = _messageController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        widget.chatItem.messages
            .add(Message(sender: "me", text: text, time: "Now"));
        _messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatItem.username),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.chatItem.messages.length,
              itemBuilder: (context, index) {
                final message = widget.chatItem.messages[index];
                final isMe =
                    message.sender == "me"; // Assume "me" represents the user
                return Dismissible(
                  key: Key(message.text + index.toString()),
                  // Unique key for Dismissible
                  direction: DismissDirection.endToStart,
                  // Only allow swipe from right to left
                  onDismissed: (direction) {
                    setState(() {
                      widget.chatItem.messages
                          .removeAt(index); // Remove the message from the list
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Message deleted")));
                  },
                  background: Container(
                    color: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Align(
                    alignment:
                        isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        color: isMe ? Colors.green[300] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(message.text),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Write your message here",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatItem {
  final String username;
  final List<Message> messages;

  ChatItem({required this.username, required this.messages});
}

class Message {
  final String sender;
  final String text;
  final String time;

  Message({required this.sender, required this.text, required this.time});
}
