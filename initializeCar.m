function car = initializeCar(index,t,lanes)

initializeDesiredSpeed = @() 30 + rand * 20;
initializeFrustration = @() 1 + rand/2;

car(index).index = index;
car(index).desiredSpeed = initializeDesiredSpeed();
car(index).frustration = initializeFrustration();
car(index).speed = 10 + rand * 40;
car(index).position = 0;
car(index).acceleration = 0;
car(index).time = t;
car(index).lane = (1 + (rand(1,lanes-1)>=.5));
car(index).honk = 0;
car = car(index);

end