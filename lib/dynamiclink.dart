// // ignore: camel_case_types

// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

// class Dynamic {
//   Future dynamic(String ref) async {
//     final uri = 'http://bloc?ref=$ref ';
//     final dynamicLinkParams = DynamicLinkParameters(
//       link: Uri.parse(uri),
//       uriPrefix: "https://blogarticle.page.link",
//       androidParameters: const AndroidParameters(packageName: "bloc"),
//     );
//     // ignore: deprecated_member_use
//     final FirebaseDynamicLinks link = await FirebaseDynamicLinks.instance;
//     final ShortDynamicLink shortDynamicLink =
//       // ignore: deprecated_member_use
//       await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);

//   return shortDynamicLink.shortUrl.toString();
//   }
// }
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

Future<String> createDynamicLink(String docid) async {
  final DynamicLinkParameters parameters = DynamicLinkParameters(
    uriPrefix: 'https://blogarticle.page.link',
    link: Uri.parse('https://yourapp.com/event?docid=$docid'),
    androidParameters: AndroidParameters(
      packageName: 'com.example.bloc',
      minimumVersion: 1,
    ),
    // iosParameters: IOSParameters(
    //   bundleId: 'com.example.yourapp',
    //   minimumVersion: '1.0.0',
    // ),
  );

  final ShortDynamicLink shortLink =
      // ignore: deprecated_member_use
      await FirebaseDynamicLinks.instance.buildShortLink(parameters);
  print("shortlink.>>>${shortLink.shortUrl}");
  return shortLink.shortUrl.toString();
}

// Future<String> createDynamicLink(String docId, String imageUrl) async {
//   final DynamicLinkParameters parameters = DynamicLinkParameters(
//     uriPrefix: 'https://blogarticle.page.link',
//     link: Uri.parse('https://yourapp.com/event?id=$docId&image=$imageUrl'),
//     androidParameters: AndroidParameters(
//       packageName: 'com.yourcompany.yourapp',
//       minimumVersion: 0,
//     ),
//     iosParameters: IOSParameters(
//       bundleId: 'com.yourcompany.yourapp',
//       minimumVersion: '0',
//     ),
//   );

//   final ShortDynamicLink shortDynamicLink =
//       await FirebaseDynamicLinks.instance.buildShortLink(parameters);
//   return shortDynamicLink.shortUrl.toString();
// }
