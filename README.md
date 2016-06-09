# Are We There Yet?

Find the distance from one place to another with a sonic range finder, a microcontroller and some code!

The Ultrasonic Range Finder transmits a pulse of (inaudible to the ear) sound and listens for the echo. The range finder calculates the distance to an object from transmission to echo time.

## Physics

A range finder operates in [pulse-width-modulations](https://en.wikipedia.org/wiki/Pulse-width_modulation) (PWM). We need to translate this to human readable units. The metric system!

Ultrasonic Pulse goes out to some target. Echo comes back. Range finder calculates this value, capturing in an internal clock/PWM. We convert it back out to centimeters!

    Distance = ( Velocity * Time ) / 2
    Time = ( 2 * Distance ) / Velocity

This is the time interval we would expect for a pulse to travel some Distance to a target.

Let Distance = 1 cm. Speed of sound is approx 340 m/s.
   
    Time = ( 2 * 0.01 ) / 340
    Time = 5.88E-5 s
    
1 cm distance change signals a change in the Echo pulse width. Increment our calculator by 1 'tick' where our calculator operates at the frequency:
    
    ( 1 / Time ) = 1 / (5.88E-5 s)
    f = 17,000 Hz
    
Using a 4MHz internal clock for the PIC16F88 means we have 1MHz instruction cycle frequency. Combine this with a 1:64 prescale value for a rate of 15,630 Hz. Now we are close to our desired frequency of 17,000 Hz.

    ( (17,000 / 15,630) - 1 ) = 8.8%
    
Our frequency needs to be 8.8% higher! In comes the OSCTUNE register.

We have 5 bits of 'tuning' for up to 12.5% scaling on our clock frequency. To increase 8.8%:

    (8.8 / 12.5 ) * 2^(5) = 0.704 * 32 = 22.53 --> 23

To get our value from the Sonic Range Finder we copy 23 (decimal) to the OSCTUNE register for a frequency of approx 17,000 Hz.


    
(Unfortunately no LaTeX in README)


## Resources / Hardware
Uses the HC-SR04 Sonic Range Finder. See the [datasheet](http://www.accudiy.com/download/HC-SR04_Manual.pdf) to learn more.

Uses the Microchip [PIC16F88](http://www.microchip.com/wwwproducts/en/PIC16F88).

Invaluable datasheet: <url>http://ww1.microchip.com/downloads/en/DeviceDoc/30487D.pdf</url>.
