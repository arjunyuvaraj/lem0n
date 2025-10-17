import 'package:flutter/material.dart';
import 'package:lemon/components/landing_banner.dart';
import 'package:lemon/components/landing_card.dart';
import 'package:lemon/components/primary_app_button.dart';
import 'package:lemon/components/testimonial_block.dart';
import 'package:lemon/pages/welcome_page.dart';
import 'package:lemon/utilities/extensions.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // HERO: Header image with gradient background as well as title and short description
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    "assets/landing_background.png",
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Welcome to".capitalized,
                            style: context.text.headlineSmall?.copyWith(
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "Lem0n".capitalized,
                            style: context.text.headlineLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Lem0n makes standing in line simple, fair, and stress-free. With a unique token for everyone, there's zero pushing, zero rushing, and zero confusion.",
                            textAlign: TextAlign.center,
                            style: context.text.bodyMedium!.copyWith(
                              fontSize: 14,
                              height: 1.5,
                              color: context.colors.onPrimary,
                            ),
                          ),
                          const SizedBox(height: 24),
                          PrimaryAppButton(
                            label: "Get Started",
                            onTap: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const WelcomePage(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 100),
                          Icon(
                            Icons.arrow_downward_rounded,
                            color: context.colors.onPrimary.withAlpha(100),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // BODY
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 36),

                    // HOW IT WORKS
                    Text(
                      "How it works".capitalized,
                      style: context.text.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    LandingCard(
                      leadingText: "01",
                      title: "Admins Open a Line",
                      body: "Event organizers start a line when they're ready.",
                    ),
                    LandingCard(
                      leadingText: "02",
                      title: "Students Join a Line",
                      body:
                          "Everyone gets a digital spot in line right on their phone.",
                    ),
                    LandingCard(
                      leadingText: "03",
                      title: "Wait Without Waiting",
                      body:
                          "Enjoy your time while Lem0n keeps track of your place.",
                    ),

                    const SizedBox(height: 18),

                    // WHY LEMON BANNER
                    LandingBanner(
                      title: "Fair. Simple. No More Chaos.",
                      subtitle:
                          "Lemon brings order to cafeterias, events, and school lines with zero stress.",
                      icon: Icons.emoji_emotions,
                    ),

                    const SizedBox(height: 18),

                    // EXTRA BENEFITS
                    Text(
                      "Extra Benefits".capitalized,
                      style: context.text.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    LandingCard(
                      leadingIcon: Icons.timer,
                      title: "Save Time",
                      body:
                          "No wasted minutes standing around — use your time productively.",
                    ),
                    LandingCard(
                      leadingIcon: Icons.notifications_active,
                      title: "Smart Notifications",
                      body:
                          "Get alerts when it's almost your turn. Never miss your spot!",
                    ),
                    LandingCard(
                      leadingIcon: Icons.people_alt,
                      title: "Group Friendly",
                      body:
                          "Queue up together with friends or classmates, hassle-free.",
                    ),

                    const SizedBox(height: 42),

                    // TESTIMONIALS
                    Text(
                      "What people are saying".capitalized,
                      style: context.text.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    TestimonialBlock(
                      quote:
                          "Lem0n made our cafeteria lines so much calmer. I can finally eat without rushing!",
                      author: "Student Council President",
                    ),
                    TestimonialBlock(
                      quote:
                          "Managing big crowds at events has never been this smooth",
                      author: "Event Organizer",
                    ),
                    const SizedBox(height: 42),

                    // FINAL CTA
                    Text(
                      "Ready to skip the chaos?".capitalized,
                      style: context.text.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    PrimaryAppButton(
                      label: "Get Started Now",
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const WelcomePage()),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // FOOTER
                    Column(
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          "Have a question?".capitalized,
                          style: context.text.headlineSmall!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text("Contact arjyuvaraj@gmail.com"),
                        const SizedBox(height: 42),
                        Text(
                          "Lem0n © 2025".capitalized,
                          style: context.text.headlineSmall?.copyWith(
                            color: context.colors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "The testimonials shown are fictional and for illustrative purposes only.",
                          textAlign: TextAlign.center,
                          style: context.text.bodySmall!.copyWith(
                            fontSize: 11,
                            color: Colors.black54.withAlpha(50),
                            fontStyle: FontStyle.italic,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 52),
                      ],
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
