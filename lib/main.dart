import 'package:flutter/material.dart';
import 'api_service.dart';
import 'user_model.dart';
import 'details_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daftar Pengguna',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto', // Gunakan font standar Material Design
      ),
      home: UserListScreen(),
    );
  }
}

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late Future<List<User>> users;

  @override
  void initState() {
    super.initState();
    users = ApiService().fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Pengguna'),
      ),
      body: FutureBuilder<List<User>>(
        future: users,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada data pengguna'));
          }

          List<User> userList = snapshot.data!;

          return ListView.builder(
            itemCount: userList.length,
            itemBuilder: (context, index) {
              final user = userList[index];

              // Menambahkan warna biru tipis setiap dua baris
              Color backgroundColor = (index % 2 == 0)
                  ? Colors.white
                  : Colors.blue.shade100; // Warna biru tipis untuk baris ganjil

              return Card(
                margin: EdgeInsets.all(8.0),
                color: backgroundColor, // Menggunakan warna latar belakang
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://www.placecage.com/200/200'), // Gambar dummy
                  ),
                  title: Text(user.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Username: ${user.username}'),
                      Text('Email: ${user.email}'),
                      Text('ID: ${user.id}'),
                      Text('Address: ${user.address.street}, '
                          '${user.address.city}, '
                          '${user.address.zipcode}'),
                      Text('Geo: Lat ${user.address.geo.lat}, '
                          'Lng ${user.address.geo.lng}')
                    ],
                  ),
                  isThreeLine: true,
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    // Navigasi ke detail alamat
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsScreen(user: user),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
