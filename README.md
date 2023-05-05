# Resizer project

## Steps of implementation

### Planning 

Results of this stage of project may be seen in folder [Docs](https://github.com/sliv2001/resizer/blob/main/doc/Проектирование.pdf).

### Coding and bring-up test

Results are in folder ./src. Most tests were conducted using usual testbenches, including no external test vectors, like in ./src/tf_resizer_0.sv file. However, test vectors acquisition capabilities are included as well (see ./src/tf_resizer.sv).

Script for synthesys is also implemented. You need to set path to your installation of Quartus in order to use it.

### Test synthesys

Here are the results of test synthesys:

| Flow Status                        | Successful - Fri May  5 15:04:28 2023          |
|------------------------------------|------------------------------------------------|
| Quartus Prime Version              | 22.1std.1 Build 917 02/14/2023 SC Lite Edition |
| Revision Name                      | resizer                                        |
| Top-level Entity Name              | resizer                                        |
| Family                             | MAX 10                                         |
| Device                             | 10M50DDF672I7G                                 |
| Timing Models                      | Final                                          |
| Total logic elements               | 613                                            |
| Total registers                    | 150                                            |
| Total pins                         | 36                                             |
| Total virtual pins                 | 0                                              |
| Total memory bits                  | 0                                              |
| Embedded Multiplier 9-bit elements | 0                                              |
| Total PLLs                         | 0                                              |
| UFM blocks                         | 0                                              |
| ADC blocks                         | 0                                              |

