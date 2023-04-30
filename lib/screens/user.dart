import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("User"),
        ),
        body: ListView(
          children: [
            const SizedBox(
              height: 24,
            ),
            Text(
              FirebaseAuth.instance.currentUser!.email!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 40,
                  ),
            ),
            const SizedBox(
              height: 32,
            ),
            Text(
              "Your recipes",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 32,
                  ),
            ),
            const SizedBox(
              height: 16,
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Meals')
                    .where('creatorId',
                        isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("Something went wrong!"),
                    );
                  }
                  final documents = snapshot.data!.docs;

                  if (documents.isEmpty) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        SizedBox(
                          height: 64,),
                        Text(
                          "You haven't added any recipes yet!",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: documents.length,
                    itemBuilder: (ctx, index) => ListTile(
                      title: Text(documents[index]['title']),
                      subtitle: Text(documents[index]['description']),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('Meals')
                              .doc(documents[index].id)
                              .delete();
                        },
                      ),
                    ),
                  );
                }),
          ],
        ));
  }
}
