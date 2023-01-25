import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ListBookSkeleton extends StatelessWidget {
  const ListBookSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Shimmer.fromColors(
                baseColor: const Color(0xffEDEDED),
                highlightColor: const Color(0xffffffff),
                child: Container(
                  height: 15,
                  width: 150,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)),
                ),
              ),
              const SizedBox(height: 5),
              Shimmer.fromColors(
                baseColor: const Color(0xffEDEDED),
                highlightColor: const Color(0xffffffff),
                child: Container(
                  height: 35,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
