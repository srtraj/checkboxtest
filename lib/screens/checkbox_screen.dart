import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/meta_text_model.dart';

class CheckBoxScreen extends StatefulWidget {
  const CheckBoxScreen({Key? key}) : super(key: key);

  @override
  State<CheckBoxScreen> createState() => _CheckBoxScreenState();
}

class _CheckBoxScreenState extends State<CheckBoxScreen> {
  String? errorMsg;
  late TextEditingController _cntMaxNoBox;
  late TextEditingController _cntMaxNoSelection;
  late TextEditingController _cntMaxNoAlphabets;
  late TextEditingController _cntMaxNoNumbers;
  late MetaTextModel metaData;
  late bool isLoading;

  @override
  void initState() {
    _cntMaxNoBox = TextEditingController();
    _cntMaxNoSelection = TextEditingController();
    _cntMaxNoAlphabets = TextEditingController();
    _cntMaxNoNumbers = TextEditingController();
    isLoading = true;
    _cntMaxNoBox.addListener(() {
      setState(() {});
    });
    _cntMaxNoSelection.addListener(() {
      setState(() {});
    });
    _cntMaxNoAlphabets.addListener(() {
      setState(() {});
    });
    _cntMaxNoNumbers.addListener(() {
      setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await readJson();
    });
    super.initState();
  }

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('json/meta_text.json');
    final data = await json.decode(response);
    metaData = MetaTextModel.fromJson(data);
    isLoading = false;
    setState(() {});
  }

  @override
  void dispose() {
    _cntMaxNoBox.dispose();
    _cntMaxNoSelection.dispose();
    _cntMaxNoAlphabets.dispose();
    _cntMaxNoNumbers.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration:
              BoxDecoration(border: Border.all(color: Colors.black, width: 5)),
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: <Widget>[
                          CustomLabelTextField(
                            label: metaData.title?.totalBox ?? "",
                            controller: _cntMaxNoBox,
                          ),
                          const Divider(
                            thickness: 5,
                            color: Colors.black,
                          ),
                          CustomLabelTextField(
                            label: metaData.title?.totalSelection ?? "",
                            controller: _cntMaxNoSelection,
                          ),
                          CustomLabelTextField(
                            label: metaData.title?.totalAlphabet ?? "",
                            controller: _cntMaxNoAlphabets,
                          ),
                          CustomLabelTextField(
                            label: metaData.title?.totalNumber ?? "",
                            controller: _cntMaxNoNumbers,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Divider(
                            thickness: 2,
                            height: 1,
                            color: Colors.black,
                          ),
                          const Divider(
                            thickness: 2,
                            height: 1,
                            color: Colors.black,
                          ),
                          if (_cntMaxNoBox.text.isNotEmpty &&
                              _cntMaxNoSelection.text.isNotEmpty &&
                              _cntMaxNoAlphabets.text.isNotEmpty &&
                              _cntMaxNoNumbers.text.isNotEmpty)
                            SelectionWidget(
                              metaData: metaData,
                              maxNoBox: _cntMaxNoBox.text.isEmpty
                                  ? 0
                                  : int.parse(_cntMaxNoBox.text),
                              maxNoSelection: _cntMaxNoSelection.text.isEmpty
                                  ? 0
                                  : int.parse(_cntMaxNoSelection.text),
                              maxNoAlphabets: _cntMaxNoAlphabets.text.isEmpty
                                  ? 0
                                  : int.parse(_cntMaxNoAlphabets.text),
                              maxNoNumbers: _cntMaxNoNumbers.text.isEmpty
                                  ? 0
                                  : int.parse(_cntMaxNoNumbers.text),
                              onError: (val) {
                                errorMsg = val;
                                setState(() {});
                              },
                            ),
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                      height: 1,
                      color: Colors.black,
                    ),
                    StatusWidget(
                        metaData: metaData,
                        maxNoBox: _cntMaxNoBox.text.isEmpty
                            ? 0
                            : int.parse(_cntMaxNoBox.text),
                        maxNoSelection: _cntMaxNoSelection.text.isEmpty
                            ? 0
                            : int.parse(_cntMaxNoSelection.text),
                        maxNoAlphabets: _cntMaxNoAlphabets.text.isEmpty
                            ? 0
                            : int.parse(_cntMaxNoAlphabets.text),
                        maxNoNumbers: _cntMaxNoNumbers.text.isEmpty
                            ? 0
                            : int.parse(_cntMaxNoNumbers.text),
                        error: errorMsg,
                        onReset: () {
                          FocusScope.of(context).unfocus();
                          _cntMaxNoBox.clear();
                          _cntMaxNoSelection.clear();
                          _cntMaxNoAlphabets.clear();
                          _cntMaxNoNumbers.clear();
                        }),
                  ],
                ),
        ),
      ),
    );
  }
}

class SelectionWidget extends StatefulWidget {
  final int maxNoBox;
  final int maxNoSelection;
  final int maxNoAlphabets;
  final int maxNoNumbers;
  final ValueSetter<String?> onError;
  final MetaTextModel metaData;
  const SelectionWidget({
    Key? key,
    required this.maxNoNumbers,
    required this.maxNoAlphabets,
    required this.maxNoSelection,
    required this.maxNoBox,
    required this.onError,
    required this.metaData,
  }) : super(key: key);

  @override
  State<SelectionWidget> createState() => _SelectionWidgetState();
}

class _SelectionWidgetState extends State<SelectionWidget> {
  late int alphabetCount;
  late int numberCount;
  bool? isFocusNumber;
  @override
  void initState() {
    alphabetCount = 0;
    numberCount = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
              child: AlphabetWidget(
            metaData: widget.metaData,
            maxNoBox: widget.maxNoBox,
            totalSelection: alphabetCount + numberCount,
            maxNoAlphabets: widget.maxNoAlphabets,
            maxNoSelection: widget.maxNoSelection,
            isFocus: isFocusNumber == false,
            onChanged: (val) {
              alphabetCount = val[0];
              isFocusNumber = false;
              widget.onError(val[1] ??
                  ((alphabetCount + numberCount == widget.maxNoSelection)
                      ? "success"
                      : null));
              setState(() {});
            },
          )),
          const VerticalDivider(
            thickness: 2,
            color: Colors.black,
          ),
          Expanded(
              child: NumberWidget(
            metaData: widget.metaData,
            maxNoBox: widget.maxNoBox,
            maxNoSelection: widget.maxNoSelection,
            isFocus: isFocusNumber == true,
            totalSelection: alphabetCount + numberCount,
            maxNoNumbers: widget.maxNoNumbers,
            onChanged: (val) {
              numberCount = val[0];
              isFocusNumber = true;
              widget.onError(val[1] ??
                  ((alphabetCount + numberCount == widget.maxNoSelection)
                      ? "success"
                      : null));
              setState(() {});
            },
          )),
        ],
      ),
    );
  }
}

class CustomLabelTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  const CustomLabelTextField(
      {Key? key, required this.label, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
      child: Row(
        children: [
          Expanded(
              child: Text(
            label,
            textAlign: TextAlign.right,
            style: const TextStyle(fontWeight: FontWeight.bold),
          )),
          const SizedBox(
            width: 10,
          ),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1)),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Center(
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2),
                ], // Only numbers can be entered
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              ),

              // Text(
              //   value.toString(),
              //   style: const TextStyle(fontSize: 18),
              // ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }
}

class AlphabetWidget extends StatefulWidget {
  final ValueSetter<List> onChanged;
  final int maxNoBox;
  final int maxNoAlphabets;
  final int totalSelection;
  final bool isFocus;
  final int maxNoSelection;
  final MetaTextModel metaData;
  const AlphabetWidget(
      {Key? key,
      required this.onChanged,
      required this.maxNoAlphabets,
      required this.totalSelection,
      required this.isFocus,
      required this.maxNoBox,
      required this.maxNoSelection,
      required this.metaData})
      : super(key: key);

  @override
  State<AlphabetWidget> createState() => _AlphabetWidgetState();
}

class _AlphabetWidgetState extends State<AlphabetWidget> {
  late List selectedList;
  late bool _isReachedMax;
  late int selectedIndex;
  @override
  void initState() {
    reset();
    super.initState();
  }

  reset() {
    selectedList = [];
    _isReachedMax = false;
    selectedIndex = -1;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(widget.maxNoBox, (index) {
            final isError =
                widget.isFocus && selectedIndex == index && _isReachedMax;
            return CustomCheckBox(
              label: String.fromCharCode(index + 'a'.codeUnitAt(0)),
              isError: isError,
              onTap: () {
                _isReachedMax = false;
                if (selectedList.contains(index)) {
                  selectedList.remove(index);
                } else {
                  if (widget.maxNoAlphabets > selectedList.length &&
                      widget.maxNoSelection > widget.totalSelection) {
                    selectedList.add(index);
                  } else {
                    _isReachedMax = true;
                  }
                }
                selectedIndex = index;
                setState(() {});
                widget.onChanged([
                  selectedList.length,
                  _isReachedMax
                      ? widget.maxNoSelection == widget.totalSelection
                          ? widget.metaData.error!.maxNoSelectionReached!
                              .replaceAll("<maxNoSelection>",
                                  widget.maxNoSelection.toString())
                          : widget.metaData.error!.maxNoAlphabetReached!
                              .replaceAll("<maxNoAlphabets>",
                                  widget.maxNoAlphabets.toString())
                      : null
                ]);
              },
              isSelected: selectedList.contains(index),
            );
          }),
        ),
      ),
    );
  }
}

class NumberWidget extends StatefulWidget {
  final ValueSetter<List> onChanged;
  final int maxNoBox;
  final int maxNoNumbers;
  final int totalSelection;
  final bool isFocus;
  final int maxNoSelection;
  final MetaTextModel metaData;
  const NumberWidget(
      {Key? key,
      required this.onChanged,
      required this.maxNoNumbers,
      required this.totalSelection,
      required this.isFocus,
      required this.maxNoBox,
      required this.maxNoSelection,
      required this.metaData})
      : super(key: key);

  @override
  State<NumberWidget> createState() => _NumberWidgetState();
}

class _NumberWidgetState extends State<NumberWidget> {
  late List selectedList;
  late bool _isReachedMax;
  late int selectedIndex;
  @override
  void initState() {
    reset();
    super.initState();
  }

  reset() {
    selectedList = [];
    _isReachedMax = false;
    selectedIndex = -1;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            widget.maxNoBox,
            (index) => CustomCheckBox(
              label: (index + 1).toString(),
              isError:
                  widget.isFocus && selectedIndex == index && _isReachedMax,
              onTap: () {
                _isReachedMax = false;
                if (selectedList.contains(index)) {
                  selectedList.remove(index);
                } else {
                  print(widget.totalSelection);
                  if (widget.maxNoNumbers > selectedList.length &&
                      widget.maxNoSelection > widget.totalSelection) {
                    selectedList.add(index);
                  } else {
                    _isReachedMax = true;
                  }
                }
                selectedIndex = index;
                setState(() {});
                widget.onChanged([
                  selectedList.length,
                  _isReachedMax
                      ? widget.maxNoSelection == widget.totalSelection
                          ? widget.metaData.error!.maxNoSelectionReached!
                              .replaceAll("<maxNoSelection>",
                                  widget.maxNoSelection.toString())
                          : widget.metaData.error!.maxNoNumberReached!
                              .replaceAll("<maxNoNumbers>",
                                  widget.maxNoNumbers.toString())
                      : null
                ]);
              },
              isSelected: selectedList.contains(index),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomCheckBox extends StatelessWidget {
  final String label;
  final Function() onTap;
  final bool isSelected;
  final bool isError;
  const CustomCheckBox(
      {Key? key,
      required this.label,
      required this.isSelected,
      required this.onTap,
      required this.isError})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration:
          isError ? BoxDecoration(border: Border.all(color: Colors.red)) : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: onTap,
            child: Container(
              margin: const EdgeInsets.all(3),
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.blueAccent)),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        size: 20.0,
                        color: Colors.black,
                      )
                    : const Icon(
                        null,
                        size: 20.0,
                        color: Colors.black,
                      ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          )
        ],
      ),
    );
  }
}

class StatusWidget extends StatelessWidget {
  final int maxNoBox;
  final int maxNoSelection;
  final int maxNoAlphabets;
  final int maxNoNumbers;
  final String? error;
  final Function onReset;
  final MetaTextModel metaData;
  const StatusWidget(
      {Key? key,
      required this.maxNoNumbers,
      required this.maxNoAlphabets,
      required this.maxNoSelection,
      required this.maxNoBox,
      this.error,
      required this.onReset,
      required this.metaData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? errorMessage;

    if (maxNoBox > 11) {
      errorMessage = metaData.error!.maxNoOfBoxAllowed;
    } else if (maxNoBox < maxNoAlphabets) {
      errorMessage = metaData.error!.maxNoOfAlphabet!
          .replaceAll("<maxNoOfBox>", maxNoBox.toString());
    } else if (maxNoBox < maxNoNumbers) {
      errorMessage = metaData.error!.maxNoOfNumber!
          .replaceAll("<maxNoOfBox>", maxNoBox.toString());
    } else if (maxNoSelection > maxNoBox * 2) {
      print(metaData.error!.maxNoOfSelections!);
      errorMessage = metaData.error!.maxNoOfSelections!
          .replaceAll("<maxNoOfBox>", (maxNoBox * 2).toString());
    } else {
      errorMessage = error;
    }
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: InkWell(
              onTap: () {
                onReset();
              },
              child: ColoredBox(
                color: Color(0xFFa24da2),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Reset all values to '0'",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          const VerticalDivider(
            thickness: 2,
            width: 1,
            color: Colors.black,
          ),
          Expanded(
            flex: 5,
            child: Container(
              height: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: errorMessage == null
                    ? null
                    : errorMessage == "success"
                        ? Colors.green
                        : Colors.red,
              ),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    errorMessage == null
                        ? ""
                        : errorMessage == "success"
                            ? "Success"
                            : "Error : $errorMessage",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
