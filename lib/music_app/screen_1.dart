import 'package:flutter/material.dart';

class Screen1 extends StatefulWidget {
  const Screen1({super.key});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 7, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.topLeft,
        children: [
          Container(
            // width: double.infinity,
            // height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                transform: GradientRotation(1),
                colors: [
                  Color(0xFF0F0817),
                  Color(0xFF771DCF),
                  Color(0xFF0F0817),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        'Welcome back!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'What do you feel like today?',
                        style: TextStyle(
                          color: Color(0xFFA4A4A4),
                          fontSize: 14,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 342,
                        height: 48,
                        decoration: ShapeDecoration(
                          color: const Color(0xFF433E48),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Row(children: [
                          SizedBox(
                            width: 8,
                          ),
                          Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'Search song, playlist, artist...',
                            style: TextStyle(
                              color: Color(0xFFA4A4A4),
                              fontSize: 14,
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
                SliverAppBar(
                  floating: true,
                  pinned: true,
                  snap: true,
                  forceElevated: true,
                  automaticallyImplyLeading: false,
                  elevation: 1,
                  backgroundColor: Colors.transparent,
                  toolbarHeight: 20,
                  bottom: TabBar.secondary(
                    overlayColor:
                        MaterialStateProperty.resolveWith<Color>((states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.green;
                      }
                      return Colors.transparent;
                    }),
                    automaticIndicatorColorAdjustment: true,
                    isScrollable: true,
                    controller: _tabController,
                    tabs: const <Widget>[
                      Tab(text: 'Overview'),
                      Tab(text: 'Specifications'),
                      Tab(text: 'Specifications'),
                      Tab(text: 'Specifications'),
                      Tab(text: 'Specifications'),
                      Tab(text: 'Specifications'),
                      Tab(text: 'Specifications'),
                    ],
                  ),
                ),
                // SliverList(
                //     delegate: SliverChildListDelegate([

                // ]))
                SliverFillRemaining(
                  child: TabBarView(
                    controller: _tabController,
                    children: const <Widget>[
                      TabBarViewBody(),
                      TabBarViewBody(),
                      TabBarViewBody(),
                      TabBarViewBody(),
                      TabBarViewBody(),
                      TabBarViewBody(),
                      TabBarViewBody(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TabBarViewBody extends StatelessWidget {
  const TabBarViewBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(
            height: 280,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            // shape: RoundedRectangleBorder(
                            //   borderRadius: BorderRadius.circular(16),
                            // ),
                            image: DecorationImage(
                                image: NetworkImage(
                                    'https://picsum.photos/id/$index/200/200')),
                            borderRadius: BorderRadius.circular(10),
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Song $index',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Description $index',
                        style: const TextStyle(
                          color: Color(0xFFA4A4A4),
                          fontSize: 14,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        SliverList.builder(
          itemBuilder: (context, index) => const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Your favourites',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          itemCount: 1,
        ),
        SliverList.builder(
          itemBuilder: (context, index) {
            return ListTile(
              leading: Image.network('https://picsum.photos/id/$index/200/200'),
              title: Text(
                'Item $index',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                'Hello $index',
                style: const TextStyle(
                  color: Color(0xFFA4A4A4),
                  fontSize: 14,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w400,
                ),
              ),
              trailing: const Text(
                '2:09',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w400,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
