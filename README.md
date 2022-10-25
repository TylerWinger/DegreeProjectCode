# DegreeProjectCode

## How to run the testbench for encoding and decoding

1. Download the following files: 
   - TB_Encoding_and_Decoding.mpf
   - Hamming_TB.v
   - Hamming_Decoding_forTB.v
   - Hamming_Encoding_forTB.v
2. Open `ModelSim`
3. Open "TB_Encoding_and_Decoding.mpf" (you may have to change what files the open explorer is looking at in the bottom right corner.)
4. It should have added 3 files: Hamming_TB.v, Hamming_Decoding_forTB.v, and Hamming_Encoding_forTB.v. If not you can open these manually by: Right clicking inside the project directory in ModelSim, then Add to Project > Existing File.
5. Right click in the project directory, Complile > Complile All. Or from the top ribbon. This will create folders inside the work directory for each of the modules.
6. In the top ribbon, Simulate > Start Simulation. This will open a window, open the word directory and choose `Hamming_TB`.
7. Add all the objects to the wave by highlighting them all, right clicking, and choosing `add to wave`.
8. In the top ribbon, set the time step to 100ms if it is not already.
9. Finally, press the `run` button or F9.
          
### Object descriptions
dataIn - is the 11 bits of data we are trying to transmit
clk - is a clock of arbitrary frequency.
codeWordOut - is formed of the data and parity bits.
dataOut - is the data decoded from the channelWord
channelWord - is the codeWord sent through a 'channel', and may contain errors
