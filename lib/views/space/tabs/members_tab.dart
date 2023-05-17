import 'package:flutter/material.dart';
import 'package:table_ease/models/member/member_model.dart';
import 'package:table_ease/services/firebase_service.dart';
import 'package:table_ease/views/space/widgets/space_member_card_widget.dart';

class MembersTab extends StatelessWidget {
  final int spaceId;

  MembersTab({super.key, required this.spaceId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseService.spacesCollection
          .doc("$spaceId")
          .collection('users')
          .snapshots(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return const Center(
            child: Text('Erro ao carregar membros.'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final userList = snapshot.data?.docs
            .map((doc) => Member.fromMap(doc.data()))
            .toList();

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: userList?.length ?? 0,
          itemBuilder: (context, index) {
            final user = userList![index];
            return SpaceMemberCardWidget(user: user);
          },
        );
      },
    );
  }
}
