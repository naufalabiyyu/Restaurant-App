import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/ui/detail_page.dart';

import '../common/navigation.dart';
import '../common/styles.dart';
import '../provider/send_review_restaurant_provider.dart';

class RatingSheet extends StatelessWidget {
  final String idUnik;
  TextEditingController reviewController = TextEditingController(text: '');
  TextEditingController nameController = TextEditingController(text: '');

  RatingSheet(
      {Key? key,
      required this.idUnik,
      required this.nameController,
      required this.reviewController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SendReviewRestaurantProvider sendReview =
        Provider.of<SendReviewRestaurantProvider>(context);

    submitRating() async {
      if (await sendReview.sendRating(
        id: idUnik,
        name: nameController.text,
        review: reviewController.text,
      )) {
        Navigation.intentWithData(DetailPage.routeName, idUnik);
      } else {}
    }

    return SingleChildScrollView(
      child: SizedBox(
        height: 400,
        child: DraggableScrollableSheet(
          initialChildSize: 1,
          minChildSize: 0.5,
          maxChildSize: 1,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text('Tulis Alasan',
                        style: primaryTextStyle.copyWith(
                            fontSize: 16, fontWeight: semiBold)),
                  ),
                  const SizedBox(height: 14),
                  Divider(
                    color: borderColor,
                  ),
                  Text(
                    'Nama :',
                    style: primaryTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: medium,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: borderColor,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: nameController,
                              style: primaryTextStyle,
                              autocorrect: false,
                              decoration: InputDecoration.collapsed(
                                hintText: 'Masukan Nama Anda',
                                hintStyle: primaryTextStyle.copyWith(
                                  fontSize: 14,
                                  fontWeight: medium,
                                  color: const Color(0xff969698),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Review :',
                    style: primaryTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: medium,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: borderColor,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: reviewController,
                              style: primaryTextStyle,
                              autocorrect: false,
                              decoration: InputDecoration.collapsed(
                                hintText: 'Masukan Review Anda',
                                hintStyle: primaryTextStyle.copyWith(
                                  fontSize: 16,
                                  fontWeight: medium,
                                  color: const Color(0xff969698),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 50,
                    margin: const EdgeInsets.only(top: 40),
                    child: TextButton(
                      onPressed: submitRating,
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.amber,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Kirim',
                        style: primaryTextStyle.copyWith(
                          fontSize: 18,
                          fontWeight: semiBold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
