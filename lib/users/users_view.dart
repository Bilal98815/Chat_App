import 'package:chat_app/chat/bloc/chat_bloc.dart';
import 'package:chat_app/chat/chat_view.dart';
import 'package:chat_app/login/bloc/login_bloc.dart';
import 'package:chat_app/login/login_view.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/shared_preferences/shared_preferences.dart';
import 'package:chat_app/users/bloc/users_bloc.dart';
import 'package:chat_app/users/bloc/users_bloc_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersView extends StatefulWidget {
  const UsersView({
    super.key,
    required this.email,
  });

  final String email;

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {

  final Preferences prefs = Preferences();

  @override
  void initState() {
    super.initState();
    context.read<UsersBloc>().fetchUsers(widget.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          prefs.clearPrferences();
          context.read<ChatBloc>().setStatus(emailId);
          context.read<LoginBloc>().logout().then(
            (value) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginView(),
                ),
              );
            },
          );
        },
        child: const Text('Logout'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: height * 0.06,
            ),
            Center(
              child: Text(
                'Users',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: font * 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(
              height: height * 0.06,
            ),
            BlocConsumer<UsersBloc, UsersBlocState>(
              listener: (context, state) {
                if (state.userApiState == APIState.error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(
                        state.errorMessage,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state.userApiState == APIState.loading) {
                  return const CircularProgressIndicator();
                }
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: ListView.builder(
                      itemCount: state.users.length,
                      itemBuilder: (context, index) {
                        final user = state.users[index];
                        return Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: height * 0.02),
                          child: Container(
                            width: width,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            child: ListTile(
                              onTap: () {
                                context.read<ChatBloc>().updateName(user.name!);
                                context.read<ChatBloc>().getStatus(user.email!);
                                context
                                    .read<ChatBloc>()
                                    .updateEmail(user.email!);
                                user2Email = user.email!;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatView(),
                                  ),
                                );
                              },
                              leading: const CircleAvatar(
                                child: Icon(Icons.person),
                              ),
                              subtitle: Text(
                                user.email!,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: font * 14,
                                ),
                              ),
                              title: Text(
                                user.name!,
                                style: TextStyle(
                                  color: Colors.indigo,
                                  fontSize: font * 27,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              height: height * 0.1,
            ),
          ],
        ),
      ),
    );
  }
}
