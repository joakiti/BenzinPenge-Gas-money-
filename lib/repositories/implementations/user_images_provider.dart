import 'package:flutter/cupertino.dart';

class UserImagesProvider {
  static const RESOURCE_PATH = "assets/";
  static const USER_ICON = "user_icon_";
  static const PNG_FORMAT = ".png";
  static const CROCODILE = "${USER_ICON}crocodile$PNG_FORMAT";
  static const EARTH = "${USER_ICON}earth$PNG_FORMAT";
  static const FISH = "${USER_ICON}fish$PNG_FORMAT";
  static const KANGAROO = "${USER_ICON}kangaroo$PNG_FORMAT";
  static const KANGAROO_REGULAR = "${USER_ICON}kangaroo_regular$PNG_FORMAT";
  static const KOALA = "${USER_ICON}koala$PNG_FORMAT";
  static const MAN = "${USER_ICON}man$PNG_FORMAT";
  static const PARROT = "${USER_ICON}parrot$PNG_FORMAT";
  static const WOMAN = "${USER_ICON}woman$PNG_FORMAT";

  Map<String, Image> images;
  Map<String, String> imageToIconName = {
    CROCODILE: "Krokodille",
    EARTH: "Jorden",
    FISH: "Fisk",
    KANGAROO: "Cooluru",
    KANGAROO_REGULAR: "Kænguru",
    KOALA: "Koala",
    MAN: "Mand",
    PARROT: "Papegøje",
    WOMAN: "Dame"
  };

  UserImagesProvider() {
    images = {
      CROCODILE: Image.asset(
        "$RESOURCE_PATH$CROCODILE",
        semanticLabel: imageToIconName[CROCODILE],
      ),
      EARTH: Image.asset(
        "$RESOURCE_PATH$EARTH",
        semanticLabel: imageToIconName[EARTH],
      ),
      FISH: Image.asset(
        "$RESOURCE_PATH$FISH",
        semanticLabel: imageToIconName[FISH],
      ),
      KANGAROO: Image.asset(
        "$RESOURCE_PATH$KANGAROO",
        semanticLabel: imageToIconName[KANGAROO],
      ),
      KANGAROO_REGULAR: Image.asset(
        "$RESOURCE_PATH$KANGAROO_REGULAR",
        semanticLabel: imageToIconName[KANGAROO_REGULAR],
      ),
      KOALA: Image.asset(
        "$RESOURCE_PATH$KOALA",
        semanticLabel: imageToIconName[KOALA],
      ),
      MAN: Image.asset(
        "$RESOURCE_PATH$MAN",
        semanticLabel: imageToIconName[MAN],
      ),
      PARROT: Image.asset(
        "$RESOURCE_PATH$PARROT",
        semanticLabel: imageToIconName[PARROT],
      ),
      WOMAN: Image.asset(
        "$RESOURCE_PATH$WOMAN",
        semanticLabel: imageToIconName[WOMAN],
      )
    };
  }

  List<Image> getAllImages() {
    return images.values.toList();
  }
}
