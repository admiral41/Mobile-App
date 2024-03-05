import 'package:bigtalk/core/failure/failure.dart';
import 'package:bigtalk/core/shared_prefs/user_shared_prefs.dart';
import 'package:bigtalk/features/auth/presentation/auth_viewmodel/auth_viewmodel.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String userId = "";

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchTextChanged);
    setUser();
  }

  void setUser() async {
    final userSharedPrefs = ref.read(userSharedPrefsProvider);
    Either<Failure, String?> user = await userSharedPrefs.getUserId();

    user.fold((failure) => {}, (user) {
      print(user);
      setState(() {
        userId = user ?? "";
      });
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchTextChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchTextChanged() {
    final authViewModel = ref.read(authViewModelProvider.notifier);
    if (_searchController.text.isEmpty) {
      authViewModel.clearSearchResults();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final authViewModel = ref.read(authViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.black,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Colors.black,
              expandedHeight: 110.0,
              elevation: 0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                expandedTitleScale: 1,
                title: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  height: 35,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white, // White background
                  ),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey.shade600),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search',
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              authViewModel.searchUserByName(context, value);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                background: Container(
                  height: 20,
                  width: 100,
                  color: Colors.black, // Black background
                  child: const SafeArea(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "Search",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                        ),
                      ), // White text
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: authState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : (authState.users?.isEmpty ?? true)
                ? const Center(
                    child: Text(
                      'Please enter a search query',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemCount: authState.users?.length ?? 0,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final user = authState.users![index];
                      final bool isFollowing = user.followers!.contains(userId);
                      String name = user.name ?? 'Unknown';
                      String username = user.username ?? 'Unknown';
                      bool isOwner = user.id == userId;

                      return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CircleAvatar(
                                backgroundImage: AssetImage('img'),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      username,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "${user.followers!.length} followers",
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isOwner) // If it's the user's own profile
                                ElevatedButton(
                                  onPressed: () {
                                    // Handle view profile action
                                    // Navigate to the user's profile screen
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side:
                                          const BorderSide(color: Colors.white),
                                    ),
                                  ),
                                  child: const Text(
                                    'View Profile',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              else // If it's not the user's own profile
                                GestureDetector(
                                  onTap: () async {
                                    if (isFollowing) {
                                      await authViewModel.unfollowUser(
                                          context, user.id!);
                                          authViewModel.searchUserByName(context, _searchController.text);
                                    } else {
                                     await  authViewModel.followUser(
                                          context, user.id!);
                                          authViewModel.searchUserByName(context, _searchController.text);
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.white),
                                    ),
                                    child: Text(
                                      isFollowing ? "Unfollow" : "Follow",
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
