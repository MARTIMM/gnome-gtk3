use v6;

#-------------------------------------------------------------------------------
unit module ExDND::Types;

#-------------------------------------------------------------------------------
enum TargetInfo is export <TEXT_HTML STRING NUMBER IMAGE TEXT_URI>;
enum DestinationType is export <
  NUMBER_DROP MARKUP_DROP TEXT_PLAIN_DROP IMAGE_DROP
>;

our %leds is export = %(
  :green(%?RESOURCES<green-on-256.png>.Str),
  :red(%?RESOURCES<red-on-256.png>.Str),
  :amber(%?RESOURCES<amber-on-256.png>.Str)
);
