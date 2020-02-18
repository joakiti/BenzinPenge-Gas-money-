import 'package:benzin_penge/repositories/implementations/user_images_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserIconPicker extends StatefulWidget {
  @override
  _UserIconPickerState createState() => _UserIconPickerState();
}

class _UserIconPickerState extends State<UserIconPicker> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0.0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(22.0),
                  child: Text(
                    "Vælg dit ikon",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.display4.merge(
                        TextStyle(
                            color:
                                Theme.of(context).primaryIconTheme.color)),
                  ),
                ),
              ),
            ],
          ),
          GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              children: buildImageColumn()),
        ],
      ),
    );
  }

  buildImageColumn() {
    UserImagesProvider p = RepositoryProvider.of<UserImagesProvider>(context);
    List<Image> images = p.getAllImages();
    List<Widget> children = images.map((img) {
      return UserIconWidget(context: context, img: img);
    }).toList();

    return children;
  }
}

class UserIconWidget extends StatelessWidget {
  const UserIconWidget({
    Key key,
    @required this.context, this.img,
  }) : super(key: key);

  final BuildContext context;
  final Image img;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.all(Radius.elliptical(50, 50)),
                      border: Border.all(
                        width: 2,
                        color: Theme.of(context).primaryIconTheme.color
                      )),
                  child: img)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Text(img.semanticLabel,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).primaryIconTheme.color,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
