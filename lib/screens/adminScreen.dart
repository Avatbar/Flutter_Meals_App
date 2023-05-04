import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meals_app/utility/utility.dart';

import 'meal_detail.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Admin"),
          actions: [
            IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 24,
              ),
              Text(
                FirebaseAuth.instance.currentUser!.email!,
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 40,
                    ),
              ),
              const SizedBox(
                height: 32,
              ),
              Text(
                "Recipes for approval",
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
                      .where('approved', isEqualTo: false)
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
                            height: 64,
                          ),
                          Text(
                            "No new recipes!",
                            textAlign: TextAlign.center,
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
                      itemBuilder: (ctx, index) => Card(
                        color: Theme.of(context).colorScheme.onSurface.value ==
                                Colors.white.value
                            ? Colors.grey[300]
                            : Colors.grey[800],
                        child: ListTile(
                          leading: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctx) => MealDetailScreen(
                                      meal: Utility().crateMeal(documents[index]),
                                    ),
                                  ));
                            },
                            child: Image(
                              image: NetworkImage(documents[index]['image']),
                              fit: BoxFit.cover,
                              width: 80,
                            ),
                          ),
                          title: Text(
                            documents[index]['title'],
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .copyWith(
                                  color: Colors.black,
                              fontWeight: FontWeight.bold,
                                ),
                          ),
                          subtitle: Text(
                            "${Utility().getAffordabilityText(documents[index])}\n${documents[index]['complexity']}",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                          trailing: Container(
                            alignment: Alignment.center,
                            width: 100,
                            height: 100,
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  foregroundDecoration: const BoxDecoration(
                                      color: Colors.black12,
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(10),
                                          bottom: Radius.circular(10)
                                      )
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    ),
                                    onPressed: () async {
                                      await FirebaseFirestore.instance
                                          .collection('Meals')
                                          .doc(documents[index].id)
                                          .update({'approved': true});
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          duration: const Duration(seconds: 1),
                                          content: const Text("Meal approved!"),
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  width: 40,
                                  height: 40,
                                  foregroundDecoration: const BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(10),
                                        bottom: Radius.circular(10)
                                    )
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () async {
                                      await FirebaseFirestore.instance
                                          .collection('Meals')
                                          .doc(documents[index].id)
                                          .delete();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          duration: const Duration(seconds: 1),
                                          content: const Text("Meal rejected!"),
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          isThreeLine: true,
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ));
  }
}
