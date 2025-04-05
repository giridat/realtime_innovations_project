
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:realtime_innovations_project/generated/assets.dart';
import 'package:realtime_innovations_project/modules/internet/bloc/internet_bloc.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(Assets.assetsNoWifiSvgrepoCom),
              const SizedBox(height: 73),
              const Text(
                'Ooops!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 34),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.8,
                child: const Text(
                  'No Internet connection found check your connection and try again.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 73),
              FilledButton(
                style: FilledButton.styleFrom(
                  fixedSize: Size(
                    MediaQuery.sizeOf(context).width * 0.9,
                    MediaQuery.sizeOf(context).height * 0.054,
                  ),
                  backgroundColor: Colors.blue,
                ),
                onPressed: () => context
                    .read<InternetBloc>()
                    .add( CheckInternetConnectivity()),
                child: const Text(
                  'Try Again',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
