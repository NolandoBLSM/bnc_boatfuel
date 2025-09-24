-- Boat Fuel Manager - SERVER SIDE
-- Handles ox_fuel compatibility

RegisterServerEvent('boat-fuel:setFuel')
AddEventHandler('boat-fuel:setFuel', function(networkId)
    local vehicle = NetworkGetEntityFromNetworkId(networkId)
    if DoesEntityExist(vehicle) then
        -- Set the entity state for ox_fuel compatibility
        Entity(vehicle).state.fuel = 100
    end
end)

print("^2[Boat Fuel Manager]^7 Server started")