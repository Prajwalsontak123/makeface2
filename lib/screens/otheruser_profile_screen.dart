import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class OtherUserProfileScreen extends StatelessWidget {
  final String username;
  final String profileImage;
  final String bio;

  const OtherUserProfileScreen({
    required this.username,
    required this.profileImage,
    required this.bio,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(username),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications_none),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align children to the left
            children: [
              _buildProfileHeader(profileImage),
              _buildProfileDetails(username, bio), // Moved to top
              _buildTabBar(),
              _buildTabView(),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildProfileHeader(String profileImage) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: CachedNetworkImageProvider(profileImage),
          ),
          Column(
            children: [
              Text('150',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              Text('Posts'),
            ],
          ),
          Column(
            children: [
              Text('2000',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              Text('Followers'),
            ],
          ),
          Column(
            children: [
              Text('180',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              Text('Following'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDetails(String username, String bio) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Align children to the left
        children: [
          Text(username, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text(bio),
          SizedBox(height: 4),
          Text('Link goes here', style: TextStyle(color: Colors.blue)),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      tabs: [
        Tab(icon: Icon(Icons.grid_on)),
        Tab(icon: Icon(Icons.video_library)),
        Tab(icon: Icon(Icons.person_pin)),
      ],
      labelColor: Colors.black,
      unselectedLabelColor: Colors.grey,
      indicatorColor: Colors.black,
    );
  }

  Widget _buildTabView() {
    return Container(
      height: 400, // Adjust the height as needed
      child: TabBarView(
        children: [
          _buildGrid(),
          Center(child: Text('IGTV Videos')),
          Center(child: Text('Tagged Posts')),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 30,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: (context, index) {
        return CachedNetworkImage(
          imageUrl: 'https://via.placeholder.com/150',
          fit: BoxFit.cover,
        );
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.add_box), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
      ],
    );
  }
}
