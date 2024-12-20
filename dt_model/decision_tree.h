// decision_tree.h
// Definizione della funzione di previsione
int classify(float features[]) {
    if (features[17] <= 4.37) {
        if (features[0] <= 45.88) {
            if (features[16] <= 50.98) {
                if (features[0] <= 33.88) {
                    if (features[12] <= 40.80) {
                        if (features[2] <= 6.68) {
                            if (features[0] <= 0.71) {
                                if (features[22] <= 1.50) {
                                    return 3;
                                } else {
                                    return 3;
                                }
                            } else {
                                return 3;
                            }
                        } else {
                            if (features[10] <= 1.96) {
                                if (features[0] <= 12.00) {
                                    return 3;
                                } else {
                                    return 3;
                                }
                            } else {
                                if (features[1] <= 11.13) {
                                    return 3;
                                } else {
                                    return 3;
                                }
                            }
                        }
                    } else {
                        return 1;
                    }
                } else {
                    if (features[9] <= 2.64) {
                        if (features[4] <= 2.41) {
                            if (features[4] <= 0.71) {
                                if (features[1] <= 3.64) {
                                    return 3;
                                } else {
                                    return 3;
                                }
                            } else {
                                if (features[1] <= 6.35) {
                                    return 1;
                                } else {
                                    return 1;
                                }
                            }
                        } else {
                            return 3;
                        }
                    } else {
                        if (features[0] <= 44.47) {
                            if (features[15] <= 8.53) {
                                if (features[7] <= 2.13) {
                                    return 1;
                                } else {
                                    return 1;
                                }
                            } else {
                                return 3;
                            }
                        } else {
                            if (features[13] <= 9.47) {
                                return 3;
                            } else {
                                if (features[9] <= 23.46) {
                                    return 2;
                                } else {
                                    return 3;
                                }
                            }
                        }
                    }
                }
            } else {
                if (features[20] <= 17.09) {
                    if (features[10] <= 14.27) {
                        return 3;
                    } else {
                        return 2;
                    }
                } else {
                    if (features[9] <= 52.09) {
                        if (features[18] <= 6.10) {
                            return 1;
                        } else {
                            return 1;
                        }
                    } else {
                        return 2;
                    }
                }
            }
        } else {
            if (features[18] <= 7.03) {
                if (features[3] <= 25.87) {
                    return 1;
                } else {
                    return 3;
                }
            } else {
                if (features[14] <= 18.11) {
                    if (features[17] <= 4.19) {
                        return 2;
                    } else {
                        return 0;
                    }
                } else {
                    if (features[5] <= 2.43) {
                        if (features[23] <= 12.37) {
                            if (features[14] <= 36.46) {
                                return 2;
                            } else {
                                return 1;
                            }
                        } else {
                            return 1;
                        }
                    } else {
                        if (features[16] <= 549.02) {
                            return 2;
                        } else {
                            if (features[18] <= 47.68) {
                                return 0;
                            } else {
                                return 0;
                            }
                        }
                    }
                }
            }
        }
    } else {
        if (features[1] <= 46.28) {
            if (features[15] <= 22.89) {
                if (features[9] <= 29.57) {
                    if (features[8] <= 31.37) {
                        if (features[21] <= 31.10) {
                            if (features[0] <= 67.76) {
                                if (features[17] <= 26.15) {
                                    return 3;
                                } else {
                                    return 1;
                                }
                            } else {
                                if (features[20] <= 58.56) {
                                    return 2;
                                } else {
                                    return 1;
                                }
                            }
                        } else {
                            if (features[10] <= 22.68) {
                                if (features[18] <= 135.67) {
                                    return 1;
                                } else {
                                    return 1;
                                }
                            } else {
                                if (features[21] <= 76.99) {
                                    return 1;
                                } else {
                                    return 1;
                                }
                            }
                        }
                    } else {
                        if (features[16] <= 1547.06) {
                            if (features[21] <= 47.95) {
                                if (features[14] <= 14.76) {
                                    return 2;
                                } else {
                                    return 2;
                                }
                            } else {
                                if (features[8] <= 86.27) {
                                    return 1;
                                } else {
                                    return 2;
                                }
                            }
                        } else {
                            if (features[8] <= 107.84) {
                                if (features[0] <= 143.29) {
                                    return 1;
                                } else {
                                    return 1;
                                }
                            } else {
                                if (features[8] <= 433.33) {
                                    return 1;
                                } else {
                                    return 0;
                                }
                            }
                        }
                    }
                } else {
                    if (features[8] <= 339.22) {
                        if (features[14] <= 23.18) {
                            if (features[21] <= 70.62) {
                                if (features[16] <= 1884.31) {
                                    return 2;
                                } else {
                                    return 1;
                                }
                            } else {
                                if (features[9] <= 67.94) {
                                    return 1;
                                } else {
                                    return 2;
                                }
                            }
                        } else {
                            if (features[9] <= 95.62) {
                                if (features[14] <= 36.24) {
                                    return 1;
                                } else {
                                    return 1;
                                }
                            } else {
                                if (features[0] <= 250.59) {
                                    return 2;
                                } else {
                                    return 0;
                                }
                            }
                        }
                    } else {
                        if (features[0] <= 558.35) {
                            if (features[16] <= 2347.06) {
                                if (features[22] <= 52.42) {
                                    return 2;
                                } else {
                                    return 0;
                                }
                            } else {
                                if (features[21] <= 233.96) {
                                    return 0;
                                } else {
                                    return 0;
                                }
                            }
                        } else {
                            if (features[8] <= 801.96) {
                                if (features[0] <= 1127.29) {
                                    return 0;
                                } else {
                                    return 0;
                                }
                            } else {
                                return 0;
                            }
                        }
                    }
                }
            } else {
                if (features[8] <= 231.37) {
                    if (features[9] <= 147.80) {
                        if (features[15] <= 35.13) {
                            if (features[9] <= 52.20) {
                                if (features[10] <= 66.18) {
                                    return 1;
                                } else {
                                    return 1;
                                }
                            } else {
                                if (features[14] <= 44.53) {
                                    return 1;
                                } else {
                                    return 1;
                                }
                            }
                        } else {
                            if (features[0] <= 319.76) {
                                if (features[10] <= 139.23) {
                                    if (features[9] <= 284.00) {
                                        if (features[0] <= 998.12) {
                                            return 1;
                                        } else {
                                            return 1;
                                        }
                                    } else {
                                        return 2;
                                    }
                                } else {
                                    return 0;
                                }
                            } else {
                                return 0;
                            }
                        }
                    } else {
                        if (features[0] <= 558.35) {
                            if (features[16] <= 2347.06) {
                                if (features[22] <= 52.42) {
                                    return 2;
                                } else {
                                    return 0;
                                }
                            } else {
                                if (features[21] <= 233.96) {
                                    return 0;
                                } else {
                                    return 0;
                                }
                            }
                        } else {
                            if (features[8] <= 801.96) {
                                if (features[0] <= 1127.29) {
                                    return 0;
                                } else {
                                    return 0;
                                }
                            } else {
                                return 0;
                            }
                        }
                    }
                }
            }
        }
    }
}
