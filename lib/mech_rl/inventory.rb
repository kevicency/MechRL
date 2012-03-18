module MechRL
  class Inventory
    attr_reader :items
    
    def initialize
      @items = []
      add_default_items
    end

    private

    def add_default_items
      @items << begin
        weapon = Mech::MissileLauncher.new
        weapon.name = "LRM 5"
        weapon.base_weight = 30
        weapon.ammo_count = 50
        weapon.ammo_weight = 0.75
        weapon.ammo_burst = 5
        weapon.ammo_heat = 2
        weapon.ammo_damage = 10
        weapon.reload_time = 15
        weapon
      end

      @items << begin
        weapon = Mech::MissileLauncher.new
        weapon.name = "MRM 20"
        weapon.base_weight = 30
        weapon.ammo_count = 150
        weapon.ammo_weight = 0.6
        weapon.ammo_burst = 20
        weapon.ammo_heat = 1.75
        weapon.ammo_damage = 13
        weapon.reload_time = 20
        weapon
      end

      @items << begin
        weapon = Mech::Gun.new
        weapon.base_weight = 8
        weapon.name = "Single Gun"
        weapon.ammo_count = 1000
        weapon.ammo_weight = 0.01
        weapon.ammo_burst = 1
        weapon.ammo_heat = 0.01
        weapon.ammo_damage = 1.5
        weapon.reload_time = 0.2

        weapon
      end

      @items << begin
        weapon = Mech::Laser.new
        weapon.name = "Strong Laser"
        weapon.base_weight = 10
        weapon.heat_generation = 15
        weapon.intensity = 40

        weapon
      end

      @items << begin
        weapon = Mech::Laser.new
        weapon.name = "Weak Laser"
        weapon.base_weight = 4
        weapon.heat_generation = 7
        weapon.intensity = 10

        weapon
      end

      @items << begin
        engine = Mech::Engine.new
        engine.name = "Better Engine"
        engine.weight = 400
        engine.power = 7500
        engine.heat_generation = 10
        engine
      end
    end

  end
end
