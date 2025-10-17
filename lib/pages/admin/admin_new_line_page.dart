import 'package:flutter/material.dart';
import 'package:lemon/components/app_text_field.dart';
import 'package:lemon/components/primary_app_button.dart';
import 'package:lemon/services/line_service.dart';
import 'package:lemon/utilities/codes.dart';
import 'package:lemon/utilities/extensions.dart';

class AdminNewLinePage extends StatelessWidget {
  const AdminNewLinePage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    return Scaffold(
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.all(48),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // HEADER: Title and Description
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Adding a ".capitalized,
                          style: context.text.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: getLetterSpacing(18, 15),
                          ),
                        ),
                        Text(
                          "line?".capitalized,
                          style: context.text.headlineSmall?.copyWith(
                            color: context.colors.primary,
                            fontWeight: FontWeight.w700,
                            letterSpacing: getLetterSpacing(18, 15),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Type in the name, and a quick description of what it's for!",
                      textAlign: TextAlign.center,
                      style: context.text.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        letterSpacing: getLetterSpacing(18, 15),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // FORM: Get the name and description and add it to the list of lines
                    AppTextField(
                      hintText: "Name",
                      controller: nameController,
                      obscureText: false,
                    ),
                    const SizedBox(height: 12),
                    AppTextField(
                      hintText: "Description",
                      controller: descriptionController,
                      obscureText: false,
                    ),
                    const SizedBox(height: 12),
                    PrimaryAppButton(
                      label: "New line".capitalized,
                      onTap: () => {
                        LineService().addLine(
                          Codes().currentSchool,
                          nameController.text,
                          descriptionController.text,
                        ),
                        nameController.text = "",
                        descriptionController.text = "",
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
