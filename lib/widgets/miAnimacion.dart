import 'package:flutter/material.dart';

class MiAnimacion extends StatefulWidget {
  MiAnimacion({Key? key}) : super(key: key);

  @override
  _MiAnimacionState createState() => _MiAnimacionState();
}

class _MiAnimacionState extends State<MiAnimacion>
    with SingleTickerProviderStateMixin {
  late AnimationController controller0;
  // animaciones
  late Animation<double> moverDerecha0;
  late Animation<double> moverArriba0;
  late Animation<double> moverArriba00;
  late Animation<double> moverIzquierda0;
  late Animation<double> moverAbajo0;

  late Animation<double> moverAbajo1;

  late Animation<double> moverDerecha2;
  late Animation<double> moverArriba2;
  late Animation<double> moverArriba22;
  late Animation<double> moverIzquierda2;
  late Animation<double> moverAbajo2;
  late Animation<double> moverAbajo22;

  late Animation<double> moverDerecha3;
  late Animation<double> moverArriba3;
  late Animation<double> moverAbajo3;

  late Animation<double> moverArriba4;
  late Animation<double> moverIzquierda4;
  late Animation<double> moverAbajo4;

  @override
  void initState() {
    controller0 = AnimationController(
        vsync: this,
        // el tiempo que dura la animacion
        duration: const Duration(milliseconds: 2000));

    moverDerecha0 = Tween(begin: 0.0, end: 30.0).animate(
        CurvedAnimation(parent: controller0, curve: const Interval(0.0, 0.083)));

    moverArriba0 = Tween(begin: 0.0, end: -30.0).animate(
        CurvedAnimation(parent: controller0, curve: const Interval(0.083, 0.16)));

    moverArriba2 = Tween(begin: 0.0, end: -30.0).animate(
        CurvedAnimation(parent: controller0, curve: const Interval(0.083, 0.16)));

    moverDerecha2 = Tween(begin: 0.0, end: 30.0).animate(
        CurvedAnimation(parent: controller0, curve: const Interval(0.16, 0.25)));

    moverAbajo2 = Tween(begin: 0.0, end: 30.0).animate(
        CurvedAnimation(parent: controller0, curve: const Interval(0.25, 0.33)));

    moverAbajo3 = Tween(begin: 0.0, end: 30.0).animate(
        CurvedAnimation(parent: controller0, curve: const Interval(0.25, 0.33)));

    moverDerecha3 = Tween(begin: 0.0, end: 30.0).animate(
        CurvedAnimation(parent: controller0, curve: const Interval(0.33, 0.41)));

    moverArriba3 = Tween(begin: 0.0, end: -30.0).animate(
        CurvedAnimation(parent: controller0, curve: const Interval(0.41, 0.5)));

    moverArriba4 = Tween(begin: 0.0, end: -30.0).animate(
        CurvedAnimation(parent: controller0, curve: const Interval(0.41, 0.5)));

    moverIzquierda4 = Tween(begin: 0.0, end: -30.0).animate(
        CurvedAnimation(parent: controller0, curve: const Interval(0.5, 0.58)));

    moverAbajo22 = Tween(begin: 0.0, end: 30.0).animate(
        CurvedAnimation(parent: controller0, curve: const Interval(0.58, 0.66)));

    moverAbajo4 = Tween(begin: 0.0, end: 30.0).animate(
        CurvedAnimation(parent: controller0, curve: const Interval(0.58, 0.66)));

    moverIzquierda2 = Tween(begin: 0.0, end: -30.0).animate(
        CurvedAnimation(parent: controller0, curve: const Interval(0.66, 0.75)));

    moverArriba00 = Tween(begin: 0.0, end: -30.0).animate(
        CurvedAnimation(parent: controller0, curve: const Interval(0.75, 0.83)));

    moverArriba22 = Tween(begin: 0.0, end: -30.0).animate(
        CurvedAnimation(parent: controller0, curve: const Interval(0.75, 0.83)));

    moverIzquierda0 = Tween(begin: 0.0, end: -30.0).animate(
        CurvedAnimation(parent: controller0, curve: const Interval(0.83, 0.91)));

    moverAbajo1 = Tween(begin: 0.0, end: 30.0).animate(
        CurvedAnimation(parent: controller0, curve: const Interval(0.91, 1)));

    moverAbajo0 = Tween(begin: 0.0, end: 30.0).animate(
        CurvedAnimation(parent: controller0, curve: const Interval(0.91, 1)));

    controller0.forward();
    controller0.addListener(() {
      setState(() {});
      if (controller0.status == AnimationStatus.completed) {
        controller0.repeat();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: controller0,
                  builder: (BuildContext context, Widget? child) {
                    return Transform.translate(
                        offset: Offset(0, moverAbajo1.value), child: child);
                  },
                  child: _Cuadrado(
                    color: gradient0,
                  ),
                ),
                AnimatedBuilder(
                  animation: controller0,
                  builder: (BuildContext context, Widget? child) {
                    return Transform.translate(
                        offset: Offset(
                            moverDerecha2.value + moverIzquierda2.value,
                            moverArriba2.value +
                                moverAbajo2.value +
                                moverAbajo22.value +
                                moverArriba22.value),
                        child: child);
                  },
                  child: _Cuadrado(
                    color: gradient1,
                  ),
                ),
                AnimatedBuilder(
                  animation: controller0,
                  builder: (BuildContext context, Widget? child) {
                    return Transform.translate(
                        offset: Offset(moverDerecha3.value,
                            moverAbajo3.value + moverArriba3.value),
                        child: child);
                  },
                  child: _Cuadrado(
                    color: gradient2,
                  ),
                ),
                AnimatedBuilder(
                  animation: controller0,
                  builder: (BuildContext context, Widget? child) {
                    return Transform.translate(
                        offset: Offset(moverIzquierda4.value,
                            moverArriba4.value + moverAbajo4.value),
                        child: child);
                  },
                  child: _Cuadrado(
                    color: gradient3,
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}

class _Cuadrado extends StatefulWidget {
  final Gradient? color;
  _Cuadrado({Key? key, this.color}) : super(key: key);

  @override
  __CuadradoState createState() => __CuadradoState();
}

class __CuadradoState extends State<_Cuadrado> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2),
      width: 25,
      height: 25,
      decoration: BoxDecoration(
          gradient: widget.color,
          borderRadius: BorderRadiusDirectional.circular(5)),
      // color: widget.color,
    );
  }
}

LinearGradient gradient0 = const LinearGradient(begin: Alignment.bottomLeft, colors: [
  Color(0xff0a1699),
  Color(0xff0a1699),
]);

LinearGradient gradient1 = const LinearGradient(begin: Alignment.bottomLeft, colors: [
  Color(0xff0a1699),
  Color(0xff0a1699),
]);

LinearGradient gradient2 = const LinearGradient(begin: Alignment.bottomLeft, colors: [
  Color(0xff0a1699),
  Color(0xff0a1699),
]);

LinearGradient gradient3 = const LinearGradient(begin: Alignment.bottomLeft, colors: [
  Color(0xff0a1699),
  Color(0xff0a1699),
]);
