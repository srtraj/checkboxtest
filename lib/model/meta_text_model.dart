class MetaTextModel {
  Title? title;
  Error? error;

  MetaTextModel({this.title, this.error});

  MetaTextModel.fromJson(Map<String, dynamic> json) {
    title = json['title'] != null ? Title.fromJson(json['title']) : null;
    error = json['error'] != null ? Error.fromJson(json['error']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (title != null) {
      data['title'] = title!.toJson();
    }
    if (error != null) {
      data['error'] = error!.toJson();
    }
    return data;
  }
}

class Title {
  String? totalBox;
  String? totalSelection;
  String? totalAlphabet;
  String? totalNumber;

  Title(
      {this.totalBox,
      this.totalSelection,
      this.totalAlphabet,
      this.totalNumber});

  Title.fromJson(Map<String, dynamic> json) {
    totalBox = json['totalBox'];
    totalSelection = json['totalSelection'];
    totalAlphabet = json['totalAlphabet'];
    totalNumber = json['totalNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalBox'] = totalBox;
    data['totalSelection'] = totalSelection;
    data['totalAlphabet'] = totalAlphabet;
    data['totalNumber'] = totalNumber;
    return data;
  }
}

class Error {
  String? maxNoSelectionReached;
  String? maxNoAlphabetReached;
  String? maxNoNumberReached;
  String? maxNoOfBoxAllowed;
  String? maxNoOfAlphabet;
  String? maxNoOfNumber;
  String? maxNoOfSelections;

  Error(
      {this.maxNoSelectionReached,
      this.maxNoAlphabetReached,
      this.maxNoNumberReached,
      this.maxNoOfBoxAllowed,
      this.maxNoOfAlphabet,
      this.maxNoOfNumber,
      this.maxNoOfSelections});

  Error.fromJson(Map<String, dynamic> json) {
    maxNoSelectionReached = json['maxNoSelectionReached'];
    maxNoAlphabetReached = json['maxNoAlphabetReached'];
    maxNoNumberReached = json['maxNoNumberReached'];
    maxNoOfBoxAllowed = json['maxNoOfBoxAllowed'];
    maxNoOfAlphabet = json['maxNoOfAlphabet'];
    maxNoOfNumber = json['maxNoOfNumber'];
    maxNoOfSelections = json['maxNoOfSelections'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['maxNoSelectionReached'] = maxNoSelectionReached;
    data['maxNoAlphabetReached'] = maxNoAlphabetReached;
    data['maxNoNumberReached'] = maxNoNumberReached;
    data['maxNoOfBoxAllowed'] = maxNoOfBoxAllowed;
    data['maxNoOfAlphabet'] = maxNoOfAlphabet;
    data['maxNoOfNumber'] = maxNoOfNumber;
    data['maxNoOfSelections'] = maxNoOfSelections;
    return data;
  }
}
