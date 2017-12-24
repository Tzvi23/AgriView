c = categorical({'Apple','Banana','Orange','Tomato'});%Alphabetic Order
     MaxValue = max(Statistics);
     MaxValue = max(MaxValue) + 0.5;
     figure;
     bar(c,Statistics);
     ylim([0 MaxValue]);
     %%Graph Labels
     %Apple 
     text(0.6,Statistics(1,1) + 0.15,'Tests');
     text(0.88,Statistics(1,2) + 0.15,'Pass');
     text(1.1,Statistics(1,3) + 0.15,'Fail');
     %Banana
     text(1.6,Statistics(2,1) + 0.15,'Tests');
     text(1.88,Statistics(2,2) + 0.15,'Pass');
     text(2.1,Statistics(2,3) + 0.15,'Fail');
     %Orange
     text(2.6,Statistics(3,1) + 0.15,'Tests');
     text(2.88,Statistics(3,2) + 0.15,'Pass');
     text(3.1,Statistics(3,3) + 0.15,'Fail');
     %Tomato
     text(3.6,Statistics(4,1) + 0.15,'Tests');
     text(3.88,Statistics(4,2) + 0.15,'Pass');
     text(4.1,Statistics(4,3) + 0.15,'Fail'); 