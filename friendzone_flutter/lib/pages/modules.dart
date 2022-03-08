import 'package:flutter/material.dart';

// Search System
class MySearchDelegate extends SearchDelegate<String> {
  // Changing the variables name may be a good idea.
  // Suggestions + initial suggestions
  final pr = ['Skiing', 'Soccer', 'Movie', 'Study', 'Hiking'];
  // ignore: non_constant_identifier_names
  final sug_pr = ['Soccer', 'Movie'];

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
            onPressed: () {
              if (query.isEmpty) {
                close(context, ''); // Close the search bar if empty
              } else {
                query = ''; // Clear the search bar
                showSuggestions(context);
              }
            },
            icon: const Icon(Icons.clear))
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
      onPressed: () {
        close(context, '');
      },
      icon: const Icon(Icons.arrow_back));

  @override
  Widget buildResults(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.abc, size: 120),
            const SizedBox(height: 48),
            Text(
              query,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 64,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );

  @override
  Widget buildSuggestions(BuildContext context) {
    // Changing some of the variable name may be a good idea.
    final suggestion = query.isEmpty
        ? sug_pr
        : pr.where((sugPl) {
            final sugLower = sugPl.toLowerCase();
            final qLower = query.toLowerCase();

            return sugLower.startsWith(qLower);
          }).toList();

    return buildSuggestionSuccess(suggestion);
  }

  Widget buildSuggestionSuccess(List<String> suggestions) => ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          final queryText = suggestion.substring(0, query.length);
          final remainingText = suggestion.substring(query.length);

          return ListTile(
            onTap: () {
              query = suggestion;
              showResults(context);
            },
            leading: const Icon(Icons.abc),
            // title: Text(suggestion)
            title: RichText(
                text: TextSpan(
              text: queryText,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              children: [
                TextSpan(
                  text: remainingText,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ],
            )),
          );
        },
      );
}
