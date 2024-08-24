import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../business_logic/phone_auth/cubit/phone_auth_cubit.dart';
import '../../constants/constants.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class AppDrawer extends StatelessWidget {
  String? phoneNumber;
  PhoneAuthCubit phoneAuthCubit = PhoneAuthCubit();

  AppDrawer({super.key});

  Widget buildDrawerHeader(context) {
    if (phoneAuthCubit.getLoggedUser() != null) {
      phoneNumber = phoneAuthCubit.getLoggedUser()!.phoneNumber;
    } else {
      phoneNumber = '';
    }
    return Column(
      children: [
        Container(
          padding: const EdgeInsetsDirectional.fromSTEB(70, 10, 70, 10),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.blue[100],
          ),
          child: Image.asset(
            'assets/images/hassan.jpg',
            fit: BoxFit.cover,
          ),
        ),
        const Text(
          'Hassan Metwally',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          phoneNumber!,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  Widget buildDrawerListItem(
      {required IconData leadingIcon,
      required String title,
      Widget? trailing,
      Function()? onTap,
      Color? color}) {
    return ListTile(
      leading: Icon(leadingIcon, color: color ?? AppColors.blue),
      title: Text(title),
      trailing: trailing ??= const Icon(
        Icons.arrow_right,
        color: AppColors.blue,
      ),
      onTap: onTap,
    );
  }

  Widget buildDrawerListItemsDivider() {
    return const Divider(
      height: 0,
      thickness: 1,
      indent: 18,
      endIndent: 24,
    );
  }

  void _launchURL(Uri url) async {
    await canLaunchUrl(url)
        ? await launchUrl(url)
        : throw 'Could not launch $url';
  }

  Widget buildIcon(IconData icon, String url) {
    return InkWell(
      onTap: () => _launchURL(Uri.parse(url)),
      child: Icon(
        icon,
        color: AppColors.blue,
        size: 35,
      ),
    );
  }

  Widget buildSocialMediaIcons() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 16),
      child: Row(
        children: [
          buildIcon(
            FontAwesomeIcons.facebook,
            'https://www.facebook.com/has.metwally',
          ),
          const SizedBox(
            width: 15,
          ),
          buildIcon(
            FontAwesomeIcons.youtube,
            'https://www.youtube.com/@hassanmetwally',
          ),
          const SizedBox(
            width: 20,
          ),
          buildIcon(
            FontAwesomeIcons.telegram,
            'https://t.me/hassanMtwally',
          ),
        ],
      ),
    );
  }

  Widget buildLogoutBlocProvider(context) {
    return BlocProvider<PhoneAuthCubit>(
      create: (context) => phoneAuthCubit,
      child: buildDrawerListItem(
        leadingIcon: Icons.logout,
        title: 'Logout',
        onTap: () async {
          await phoneAuthCubit.logOut();
          Navigator.of(context).pushReplacementNamed(loginScreen);
        },
        color: Colors.red,
        trailing: const SizedBox(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 280,
            child: DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue[100]),
              child: buildDrawerHeader(context),
            ),
          ),
          buildDrawerListItem(
            leadingIcon: Icons.person,
            title: 'My Profile',
            onTap: () {},
          ),
          buildDrawerListItemsDivider(),
          buildDrawerListItem(
            leadingIcon: Icons.history,
            title: 'Places History',
            onTap: () {},
          ),
          buildDrawerListItemsDivider(),
          buildDrawerListItem(
            leadingIcon: Icons.settings,
            title: 'Settings',
            onTap: () {},
          ),
          buildDrawerListItemsDivider(),
          buildDrawerListItem(
            leadingIcon: Icons.help,
            title: 'Help',
            onTap: () {},
          ),
          buildDrawerListItemsDivider(),
          buildLogoutBlocProvider(context),
          const SizedBox(
            height: 155,
          ),
          ListTile(
            leading: Text(
              'Follow us',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          buildSocialMediaIcons(),
        ],
      ),
    );
  }
}
