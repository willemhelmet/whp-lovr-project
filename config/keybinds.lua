-- config/keybinds.lua

local Keybinds = {}

Keybinds.move = {
  type = "vector2",
  bindings = {
    {
      device = "keyboard",
      positive_x = "h",
      negative_x = "f",
      positive_y = "t",
      negative_y = "g"
    },
    {
      device = "vr",
      source = "left",
      input = "thumbstick"
    }
  }
}

Keybinds.thumbstickRight = {
  type = 'vector2',
  bindings = {
    {
      device = 'keyboard',
      positive_x = 'l',
      negative_x = 'j',
      positive_y = 'i',
      negative_y = 'k',
    },
    {
      device = 'vr',
      source = 'left',
      input = 'thumbstick'
    }
  }
}

Keybinds.smoothTurn = {
  type = "vector2",
  bindings = {
    {
      device = "keyboard",
      positive_x = "l",
      negative_x = "j"
    },
    {
      device = "vr",
      source = "right",
      input = "thumbstick",
    }
  }
}

Keybinds.grabLeft = {
  type = "float",
  bindings = {
    {
      device = "keyboard",
      key = "y"
    },
    {
      device = "vr",
      source = "left",
      input = "grip"
    },
  },
}

Keybinds.grabRight = {
  type = "float",
  bindings = {
    {
      device = "keyboard",
      key = "o"
    },
    {
      device = "vr",
      source = "right",
      input = "grip"
    }
  },
}

Keybinds.triggerLeft = {
  type = "float",
  bindings = {
    {
      device = "keyboard",
      key = "r"
    },
    {
      device = "vr",
      source = "left",
      input = "trigger"
    },
  }
}

Keybinds.triggerRight = {
  type = "float",
  bindings = {
    {
      device = "keyboard",
      key = "u"
    },
    {
      device = "vr",
      source = "right",
      input = "trigger"
    }
  }
}

Keybinds.a = {
  type = 'boolean',
  bindings = {
    {
      device = 'keyboard',
      key = 'm'
    },
    {
      device = "vr",
      source = 'left',
      input = 'a'
    }
  },
}

Keybinds.b = {
  type = 'boolean',
  bindings = {
    {
      device = 'keyboard',
      key = 'n'
    },
    {
      device = 'vr',
      source = 'left',
      input = 'b'
    }
  }
}

Keybinds.x = {
  type = 'boolean',
  bindings = {
    {
      device = 'keyboard',
      key = 'b'
    },
    {
      device = "vr",
      source = 'left',
      input = 'x'
    }
  },
}

Keybinds.y = {
  type = 'boolean',
  bindings = {
    {
      device = 'keyboard',
      key = 'v'
    },
    {
      device = 'vr',
      source = 'left',
      input = 'y'
    }
  }
}

Keybinds.thumbstickClickLeft = {
  type = 'boolean',
  bindings = {
    {
      device = 'keyboard',
      key = ','
    },
    {
      device = 'vr',
      source = 'left',
      input = 'thumbstick'
    }
  }
}

Keybinds.thumbstickClickRight = {
  type = 'boolean',
  bindings = {
    {
      device = 'keyboard',
      key = '.'
    },
    {
      device = 'vr',
      source = 'left',
      input = 'thumbstick'
    }
  }
}

Keybinds.quit = {
  type = "boolean",
  bindings = {
    {
      device = "keyboard",
      key = "escape"
    }
  }
}

return Keybinds
