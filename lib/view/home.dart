import 'package:flutter/material.dart';

import '../api/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var sizes = ['Small', 'Medium', 'Large'];
  var values = ['256x256', '512x512', '1024x1024'];
  String? dropValue;
  var textController = TextEditingController();
  String? image;
  var isLoaded = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Think Draw AI'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextFormField(
                            controller: textController,
                            decoration: const InputDecoration(
                              hintText: 'Write your imagination here',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButton(
                          hint: const Text('Select Size'),
                          value: dropValue,
                          items: List.generate(
                            sizes.length,
                            (index) => DropdownMenuItem(
                              value: values[index],
                              child: Text(sizes[index]),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              dropValue = value.toString();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    width: 250,
                    child: ElevatedButton(
                        onPressed: () async {
                          if (textController.text.isNotEmpty &&
                              dropValue!.isNotEmpty) {
                            setState(() {
                              isLoaded = false;
                            });
                            image = await AiAPI.generateImage(
                                textController.text, dropValue!);
                            setState(() {
                              isLoaded = true;
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Please Write Your Imagination & Select Size'),
                              ),
                            );
                          }
                        },
                        child: const Text('Generate Your Imagination')),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: isLoaded
                  ? Image.network(image!)
                  : Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/gifs/ball.gif'),
                          const Text(
                              textAlign: TextAlign.center,
                              'Wait!\nYour Imagination will be shown here'),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
