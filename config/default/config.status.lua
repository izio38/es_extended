Config.Modules.Status = {
  UseEffects         = true,
  UseExperimental    = false,
  StatusMax          = 100,
  TickTime           = 1000,
  UpdateInterval     = 20,
  StatusIndex        = {"stress", "drunk", "weed", "cocaine", "heroin", "meth", "thirst", "hunger"},
  NotificationValues = {0,1,2,3,4,5,6,7,8,9,10,15,20,25,50,75,100},
  DefaultValues      = {0,0,0,0,0,0,100,100},
  StatusInfo         = {
    ["hunger"] = {
      color    = "orange",
      iconType = "fontawesome",
      icon     = "fa-hamburger",
      fadeType = "desc"
    },
    ["thirst"] = {
      color    = "cyan",
      iconType = "fontawesome",
      icon     = "fa-tint",
      fadeType = "desc"
    },
    ["weed"] = {
      color    = "green",
      iconType = "fontawesome",
      icon     = "fa-cannabis",
      fadeType = "asc"
    },
    ["cocaine"] = {
      color    = "white",
      iconType = "fontawesome",
      icon     = "fa-caret-up",
      fadeType = "asc"
    },
    ["heroin"] = {
      color    = "brown",
      iconType = "fontawesome",
      icon     = "fa-syringe",
      fadeType = "asc"
    },
    ["meth"] = {
      color    = "yellow",
      iconType = "fontawesome",
      icon     = "fa-skull-crossbones",
      fadeType = "asc"
    },
    ["drunk"] = {
      color    = "purple",
      iconType = "fontawesome",
      icon     = "fa-glass-martini-alt",
      fadeType = "asc"
    },
    ["stress"] = {
      color    = "pink",
      iconType = "fontawesome",
      icon     = "fa-brain",
      fadeType = "asc"
    }
  },
  RandomEvents = {
    [1] = {action = 3,  duration = 800},   -- Brake/Reverse
    [2] = {action = 4,  duration = 1500},  -- Left 90 Degrees & Brake
    [3] = {action = 5,  duration = 1500},  -- Right 90 Degrees & Brake
    [4] = {action = 6,  duration = 800},   -- Brake Strong
    [5] = {action = 7,  duration = 1500},  -- Turn and Accelerate
    [5] = {action = 13, duration = 1500}, -- Turn Left & Reverse
    [5] = {action = 14, duration = 1500}, -- Turn Left & Reverse
    [6] = {action = 19, duration = 800},  -- Strong Brake & Turn LEft/Right
    [7] = {action = 23, duration = 800},  -- Accelerate Fast
    [8] = {action = 31, duration = 800},  -- Accelerate & Handbrake
    [9] = {action = 32, duration = 800}   -- Accelerate Very Strong
  }
}
