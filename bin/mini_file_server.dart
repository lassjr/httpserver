import 'dart:async';
import 'dart:io';
import 'package:rpi_gpio/gpio.dart';
import 'dart-ext:rpi_gpio_ext';
import 'package:rpi_gpio/src/gpio_const.dart';
import 'package:rpi_gpio/rpi_gpio.dart';

Gpio gpio = new RpiGpio();
final pin1 = gpio.output(12);

Future runEndPoint(GpioOutput pin, {Duration blink, int debounce}) async {
  for (int count = 0; count < 3; ++count) {
    pin.value = true;
    await new Future.delayed(blink);
    pin.value = false;
    await new Future.delayed(blink);
  }
  gpio.dispose();
}

Future stopEndPoint(GpioOutput pin, {Duration blink, int debounce}) async {
  for (int count = 0; count < 9; ++count) {
    pin.value = true;
    await new Future.delayed(blink);
    pin.value = false;
    await new Future.delayed(blink);
  }
  gpio.dispose();
}

Future main() async {
  var server;

  try {
    server = await HttpServer.bind("0.0.0.0", 4044);
  } catch (e) {
    print("Couldn't bind to port 4044: $e");
    exit(-1);
  }

  await for (HttpRequest request in server) {
    final q = request.uri.queryParameters['q'];
    final response = request.response;
    

    if (q == 1) {
      runEndPoint(pin1,
          blink: const Duration(milliseconds: 500), debounce: 250);
    } else if (q == 0) {
      runStopPoint(pin1,
          blink: const Duration(milliseconds: 500), debounce: 250);
    }

    request.response
      ..statusCode = HttpStatus.notFound
    response.close();
  }
}
