//decision_tree_allsubject trained with giampiero data, and all other subjects - class 2 is walking
int classify(float features[]) {
    if (features[17] <= 4.37) {
        if (features[0] <= 45.88) {
            if (features[0] <= 2.82) {
                if (features[21] <= 2.18) {
                    if (features[12] <= 3.92) {
                        if (features[0] <= 2.12) {
                            if (features[0] <= 1.41) {
                                return 3; // class: 3
                            } else {
                                return 3; // class: 3
                            }
                        } else {
                            if (features[11] <= 1.96) {
                                return 3; // class: 3
                            } else {
                                return 3; // class: 3
                            }
                        }
                    } else {
                        if (features[10] <= 6.00) {
                            if (features[15] <= 6.02) {
                                return 3; // class: 3
                            } else {
                                return 3; // class: 3
                            }
                        } else {
                            if (features[15] <= 3.35) {
                                return 3; // class: 3
                            } else {
                                return 3; // class: 3
                            }
                        }
                    }
                } else {
                    if (features[17] <= 3.92) {
                        if (features[17] <= 3.17) {
                            if (features[19] <= 9.40) {
                                return 3; // class: 3
                            } else {
                                return 1; // class: 1
                            }
                        } else {
                            if (features[8] <= 7.84) {
                                return 1; // class: 1
                            } else {
                                return 3; // class: 3
                            }
                        }
                    } else {
                        if (features[14] <= 17.65) {
                            if (features[7] <= 1.41) {
                                return 3; // class: 3
                            } else {
                                return 3; // class: 3
                            }
                        } else {
                            return 1; // class: 1
                        }
                    }
                }
            } else {
                if (features[15] <= 3.08) {
                    if (features[2] <= 3.72) {
                        if (features[0] <= 24.71) {
                            if (features[5] <= 1.73) {
                                return 3; // class: 3
                            } else {
                                return 3; // class: 3
                            }
                        } else {
                            if (features[4] <= 2.41) {
                                return 3; // class: 3
                            } else {
                                return 3; // class: 3
                            }
                        }
                    } else {
                        if (features[0] <= 26.12) {
                            if (features[2] <= 6.68) {
                                return 3; // class: 3
                            } else {
                                return 3; // class: 3
                            }
                        } else {
                            return 3; // class: 3
                        }
                    }
                } else {
                    if (features[18] <= 8.73) {
                        if (features[0] <= 31.06) {
                            if (features[5] <= 0.49) {
                                return 3; // class: 3
                            } else {
                                return 3; // class: 3
                            }
                        } else {
                            if (features[15] <= 4.89) {
                                return 1; // class: 1
                            } else {
                                return 3; // class: 3
                            }
                        }
                    } else {
                        if (features[20] <= 13.86) {
                            return 2; // class: 2
                        } else {
                            if (features[9] <= 45.08) {
                                return 1; // class: 1
                            } else {
                                return 2; // class: 2
                            }
                        }
                    }
                }
            }
        } else {
            if (features[1] <= 10.56) {
                if (features[16] <= 19.61) {
                    if (features[0] <= 61.41) {
                        return 1; // class: 1
                    } else {
                        if (features[1] <= 9.67) {
                            if (features[0] <= 68.47) {
                                return 1; // class: 1
                            } else {
                                return 1; // class: 1
                            }
                        } else {
                            if (features[0] <= 262.59) {
                                return 0; // class: 0
                            } else {
                                return 1; // class: 1
                            }
                        }
                    }
                } else {
                    if (features[22] <= 27.60) {
                        if (features[1] <= 6.45) {
                            if (features[10] <= 34.15) {
                                return 2; // class: 2
                            } else {
                                return 0; // class: 0
                            }
                        } else {
                            return 2; // class: 2
                        }
                    } else {
                        if (features[14] <= 20.53) {
                            return 1; // class: 1
                        } else {
                            return 1; // class: 1
                        }
                    }
                }
            } else {
                if (features[14] <= 4.53) {
                    if (features[1] <= 48.47) {
                        if (features[0] <= 244.94) {
                            return 3; // class: 3
                        } else {
                            return 0; // class: 0
                        }
                    } else {
                        return 3; // class: 3
                    }
                } else {
                    if (features[0] <= 281.65) {
                        if (features[8] <= 396.08) {
                            return 2; // class: 2
                        } else {
                            return 1; // class: 1
                        }
                    } else {
                        if (features[5] <= 4.85) {
                            return 0; // class: 0
                        } else {
                            return 0; // class: 0
                        }
                    }
                }
            }
        }
    } else {
        if (features[1] <= 40.80) {
            if (features[0] <= 210.35) {
                if (features[15] <= 24.04) {
                    if (features[9] <= 29.59) {
                        if (features[10] <= 20.22) {
                            if (features[18] <= 69.03) {
                                return 1; // class: 1
                            } else {
                                return 1; // class: 1
                            }
                        } else {
                            if (features[20] <= 62.75) {
                                return 2; // class: 2
                            } else {
                                return 1; // class: 1
                            }
                        }
                    } else {
                        if (features[14] <= 23.13) {
                            if (features[17] <= 431.77) {
                                return 2; // class: 2
                            } else {
                                return 1; // class: 1
                            }
                        } else {
                            if (features[9] <= 96.71) {
                                return 1; // class: 1
                            } else {
                                return 2; // class: 2
                            }
                        }
                    }
                } else {
                    if (features[9] <= 159.37) {
                        if (features[8] <= 188.24) {
                            if (features[15] <= 39.19) {
                                return 1; // class: 1
                            } else {
                                return 1; // class: 1
                            }
                        } else {
                            if (features[15] <= 58.45) {
                                return 2; // class: 2
                            } else {
                                return 1; // class: 1
                            }
                        }
                    } else {
                        if (features[15] <= 96.00) {
                            if (features[8] <= 601.96) {
                                return 2; // class: 2
                            } else {
                                return 0; // class: 0
                            }
                        } else {
                            if (features[9] <= 371.88) {
                                return 1; // class: 1
                            } else {
                                return 0; // class: 0
                            }
                        }
                    }
                }
            } else {
                if (features[0] <= 740.47) {
                    if (features[8] <= 413.73) {
                        if (features[16] <= 19.61) {
                            return 1; // class: 1
                        } else {
                            return 2; // class: 2
                        }
                    } else {
                        return 0; // class: 0
                    }
                } else {
                    if (features[0] <= 1319.24) {
                        return 2; // class: 2
                    } else {
                        if (features[5] <= 8.85) {
                            return 0; // class: 0
                        } else {
                            return 0; // class: 0
                        }
                    }
                }
            }
        } else {
            if (features[0] <= 143.75) {
                if (features[0] <= 35.83) {
                    if (features[19] <= 5.85) {
                        return 1; // class: 1
                    } else {
                        return 1; // class: 1
                    }
                } else {
                    return 2; // class: 2
                }
            } else {
                return 2; // class: 2
            }
        }
    }
}
