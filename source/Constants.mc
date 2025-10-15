import Toybox.Attention;

// Global constants for PadelScoreBoard

const PAUSE     = 0;
const NOTE_C3	= 130;
const NOTE_CS3	= 138;
const NOTE_D3	= 146;
const NOTE_DS3	= 155;
const NOTE_E3	= 164;
const NOTE_F3	= 174;
const NOTE_FS3	= 185;
const NOTE_G3	= 196;
const NOTE_GS3	= 207;
const NOTE_A3	= 220;
const NOTE_AS3	= 233;
const NOTE_B3	= 246;
const NOTE_C4	= 261;
const NOTE_CS4	= 277;
const NOTE_D4	= 293;
const NOTE_DS4	= 311;
const NOTE_E4	= 329;
const NOTE_F4	= 349;
const NOTE_FS4	= 369;
const NOTE_G4	= 392;
const NOTE_GS4	= 415;
const NOTE_A4	= 440;
const NOTE_AS4	= 466;
const NOTE_B4	= 493;
const NOTE_C5	= 523;
const NOTE_CS5	= 554;
const NOTE_D5	= 587;
const NOTE_DS5	= 622;
const NOTE_E5	= 659;
const NOTE_F5	= 698;
const NOTE_FS5	= 739;
const NOTE_G5	= 783;
const NOTE_GS5	= 830;
const NOTE_A5	= 880;
const NOTE_AS5	= 932;
const NOTE_B5	= 987;
const NOTE_C6	= 1046;
const NOTE_CS6	= 1108;
const NOTE_D6	= 1174;
const NOTE_DS6	= 1244;
const NOTE_E6	= 1318;
const NOTE_F6	= 1396;
const NOTE_FS6	= 1479;
const NOTE_G6	= 1567;
const NOTE_GS6	= 1661;
const NOTE_A6	= 1760;
const NOTE_AS6	= 1864;
const NOTE_B6	= 1975;
const NOTE_C7	= 2093;
const NOTE_CS7	= 2217;
const NOTE_D7	= 2349;
const NOTE_DS7	= 2489;
const NOTE_E7	= 2637;
const NOTE_F7	= 2793;
const NOTE_FS7	= 2959;
const NOTE_G7	= 3135;
const NOTE_GS7	= 3322;
const NOTE_A7	= 3520;
const NOTE_AS7	= 3729;
const NOTE_B7	= 3951;

const PLAYER_SWAP_SOUND = [
    new Attention.ToneProfile(NOTE_G5, 160),
    new Attention.ToneProfile(NOTE_C6, 160),
    new Attention.ToneProfile(NOTE_E6, 80),
    new Attention.ToneProfile(NOTE_C6, 80),
    new Attention.ToneProfile(NOTE_G5, 160),
    new Attention.ToneProfile(NOTE_E6, 160),
    new Attention.ToneProfile(NOTE_C6, 160),
];


const TEAM_SWAP_SOUND = [
    new Attention.ToneProfile(NOTE_G5, 200),
    new Attention.ToneProfile(PAUSE, 10),
    new Attention.ToneProfile(NOTE_G5, 200),
    new Attention.ToneProfile(NOTE_E5, 300),
];

const TEAM_WIN_SOUND = [
    new Attention.ToneProfile(NOTE_D5, 100),
    new Attention.ToneProfile(PAUSE, 10),
    new Attention.ToneProfile(NOTE_D5, 100),
    new Attention.ToneProfile(PAUSE, 10),
    new Attention.ToneProfile(NOTE_D5, 100),
    new Attention.ToneProfile(NOTE_G5, 300),
    new Attention.ToneProfile(NOTE_B5, 100),

    new Attention.ToneProfile(PAUSE, 200),

    new Attention.ToneProfile(NOTE_D5, 100),
    new Attention.ToneProfile(PAUSE, 10),
    new Attention.ToneProfile(NOTE_D5, 100),
    new Attention.ToneProfile(PAUSE, 10),
    new Attention.ToneProfile(NOTE_D5, 100),
    new Attention.ToneProfile(NOTE_G5, 300),
    new Attention.ToneProfile(NOTE_B5, 100),

    new Attention.ToneProfile(PAUSE, 200),

    new Attention.ToneProfile(NOTE_G5, 200),
    new Attention.ToneProfile(PAUSE, 10),
    new Attention.ToneProfile(NOTE_G5, 100),
    new Attention.ToneProfile(PAUSE, 10),
    new Attention.ToneProfile(NOTE_FS5, 100),
    new Attention.ToneProfile(PAUSE, 10),
    new Attention.ToneProfile(NOTE_FS5, 100),
    new Attention.ToneProfile(PAUSE, 10),
    new Attention.ToneProfile(NOTE_E5, 100),
    new Attention.ToneProfile(PAUSE, 10),
    new Attention.ToneProfile(NOTE_E5, 100),
    new Attention.ToneProfile(PAUSE, 10),
    new Attention.ToneProfile(NOTE_D5, 200),
];