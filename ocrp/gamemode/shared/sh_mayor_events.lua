GM.OCRP_Economy_Events = {} 
--- Dont use spaces in Event_
GM.OCRP_Economy_Events["Event_War01"] = {
	Name = "Conflicts With Pulsar City",
	Desc = "Due to the terrible suituation with pulsar city, they have threatened to goto war, this war will damage your economy seeing as the citizens of pulsar city have become crazed and will stop at nothing to end this conflict. Your only choice is to pay off some officals of pulsar city and this thing will disappear, otherwise you will end up in conflict and your economy will suffer.",-- The description
	Choices = {
		{
			Name = "Go to war.",
			Reward = false,
			Ecolose = 6,
			FailText = "The war was short, but it did hurt your enconomy. The pulsar city officials were accused of spending city funds on themselves and people revolted. Its safe to say that those officials won't be seen again.",
		},
		{
			Name = "Buy your way out.",
			Reward = true,
			Ecogain = 0,
			Price = 300,
			RewardText = "The pulsar city officials decided to back down! The money you sent them got leaked to the public and those officials were voted out of office.",
		},
	},
	Chance = false,
	Ignore = false,
	}
	
GM.OCRP_Economy_Events["Event_Stock01"] = {
	Name = "New Stock Available",
	Desc = "There is some new stock availible for a new company that focuses on developing weapons. The company could collapse and it could also sky-rocket. If it does sky-rocket then your economy will be boosted any your city will recieve a large payoff. ",
	Choices = {
		{
			Name = "Invest in stock.",
			Price = 150,
			Ecogain = 3,
			Ecolose = 3,
			RewardText = "The company began selling, and had a huge break through in the technology of human battle suits. They called one of these suits Ironman, and made it a private stock, selling all the older research plans to the military. Either way, you still receive a large payoff for buying stock when it was cheap.",
			FailText = "The company plummeted, the only remaining relic of it was the whole it left in your cities budget. Stock prices have dropped.",
			MoneyReward = 500,
		},
	},
	Ignore = true,
	Chance = true,
}  
GM.OCRP_Economy_Events["Event_Parade01"] = {
	Name = "Parade Prediciment",
	Desc = "Due to lack of events throughout your city, your advisory staff has recommended you run an event, in this case its a parade. The parade is expected to cost a mere 150 dollars, but the choice ultimatly rests upon your shoulders. What will you decide?",
	Choices = {
		{
			Name = "Don't throw the parade.",
			Reward = false,
			Ecolose = 4,
			FailText = "No parade, no reward. Its that simple. Even worse people gave you criticism for how lazy you have been.",
		},
		{
			Name = "Do the parade.",
			Price = 150,
			Ecogain = 10,
			RewardText = "The parade was a huge success, tons of people arrived excited for the new parade. Citizens are buying merchandise from the after parade shops, your economy is gonna be  booming!",
			Reward = true,
		},
	},
	Chance = false,
	Ignore = false,
 }
 
 
GM.OCRP_Economy_Events["Event_Economy01"] = {
	Name = "An Inactive Economy",
	Desc = "Lately the cities Economy has been at a standstill, nothing has gone up, nothing has gone down. Your advisory council has considered the thought of printing more money in order to stimulate the economy. However if you do do this, there is a chance that the money you print could cause inflation. The economy could tank if there is an excess of printed money. If you print the right amount however, you economy will receive a significance boost. It is recommended that you leave this issue alone, unless your economy is doing poorly, as this is a desperate attempt at redemption.",

	Choices = {
		{
			Name = "Print More Money.",
			Ecogain = 12,
			Ecolose = 12,
			RewardText = "After printing some more money, and then distrubuting it, more and more people began to withdraw from their bank accounts. This led to more spending. The economy has been booming ever since, and your ratings as mayor have sky-rocketed. Congratulations.",
			FailText = "The workers at the money printing facility received a false number, and printed way too much money than they were supposed to. As well as that, some of the workers reported a number of thefts from the excess supply. The media swarmed in order to get a first hand report of this disaster. Your economy has plummeted, and money has become almost worthless. I'd be watching out for some violent reprocussions.",
		},
		{
			Name = "Don't Print More Money.",
			Ecogain = 12,
			Ecolose = 12,
			RewardText = "Its a mirical, new products sprung out of nowhere and people began purchasing them like mad! The economy has recovered and your rated as the best mayor this town has had!",
			FailText = "Nothing happened, and the economy stayed inactive. Trouble's a-brewing. ",
		},
	},
	Ignore = true,
	Chance = true,
 }
 
GM.OCRP_Economy_Events["Event_Speech01"] = {
	Name = "Public Speech",-- The Name
	Desc = "Your advisorys are worried that the citizens are unsatisfied, they want you to give a speech regarding the conditions of the city. Players have been wondering about the economy and how city affairs are going. If you do not choose to organize the speech, then citizens are bound to become angry. This will hurt the economy.",-- The description
	Choices = {
		{	Name = "Do not give a speech.",
			Ecolose = 5,-- EcoPoints Lost
			Reward = false,
		},
		{
			Name = "Organize the Speech.",
			Reward = true,
			Price = 100,
			Ecogain = 8,
			RewardText = "Citizens respected what you had to say, and the support for the city has increased.",
		},
	},
 }
 
 GM.OCRP_Economy_Events["Event_Economy_ATM"] = {
	Name = "ATM Fraud",
	Desc = "Police have just discovered that the ATM machine outside of the bank has been used by criminals to gain the credit card details of almost everyone in the city. This means that a lot of people in the city have just lost thousands of dollars and will be expecting compensation. This also means that the citizens may also damage the economy by withdrawing all their savings in an attempt to not lose anymore money, they will also probably not spend this money. You can give citizens a large amount of compensation to make up for the losses and also publicly announce the problem or you could do nothing and see if citizens won't notice the increase of credit card fraud",
	Choices = {
		{
			Name = "Give citizens some compensation and have a conference about the recent fraud",
			Price = 400,
			Ecogain = 6,
			Ecolose = 2,
			RewardText = "After giving your citizens compensation and announcing the recent fraud and giving out a beautifully scripted speech about the city cracking down on criminal activity the citizens were happy that they had recieved money from their losses and they were also influenced by your speech to help crack down on crime. The citizens spend their compensation money on anything in sight and the economy has benefited greatly from this",
			FailText = "Although your citizens have the compensation and trust they needed, they still don't trust the ATMs and kept their money elsewere",
		},
		{
			Name = "Do nothing and hope for the best",
			Ecogain = 2,
			Ecolose = 6,
			RewardText = "Seems like your police force is ontop of this one, and covered your back. They found the criminals and issed a full refund of all reported theft and frauds. Lucky you.",
			FailText = "The citizens are truly pissed off, they now see you as a significant threat to the city due to your dishonesty. The citizens all rushed to the banks and withdrew as much money as they had in their saving accounts. The banks are suffering from heavy losses and bailing them out will only damage the economy more. You look out of the mayor's office window and all you can see is chaos as the city tears itself apart. What have you done ?",
		},
	},
	Ignore = false,
	Chance = true,
 }
 
 GM.OCRP_Economy_Events["Event_Power01"] = {
	Name = "City Power Consumption",-- The Name
	Desc = "Your advisory council has noticed that the lights in your city consume an excess of power. Your adviosry council and the national power grid want to help you get rid of these high consumption bulbs and replace them with green energy efficient bulbs!",
	Choices = {
		{
			Name = "Back the Great Cause",
			Reward = true,
			Price = 400,
			Ecogain = 6,
			RewardText = "The latest electric bill states that Power consumption is now at an all time low, meaning more money can go towards the community!",
		},
		{
			Name = "Declined, I'm happy with what I have.",
			Reward = false,
			Ecolose = 2,
			FailText = "Unfourtunatly, because you didnt replace the bulbs, power consumption kept at the same rate, causing more money to be spent on it.",
		},
	},
	Ignore = false,
	Chance = false,
   }
   
 GM.OCRP_Economy_Events["Event_Electricity01"] = {
	Name = "Power Outs",-- The Name
	Desc = "Due to the terrible cabling that runs through the city business and home owners experience blackouts! These blackouts are costing the utilities $1000's every time a blackout occurs.You need to upgrade the transformers! Doing this will boost your economy because business will no longer struggle from these frequent black outs.",
	Choices = {
		{
			Name = "Upgrade Generators",
			Reward = true,
			Price = 100,
			Ecogain = 6,
			MoneyReward = 100,
			RewardText = "The transformers have been upgraded, we thank you so much!",
		},
		{
			Name = "Stick with the current ones",
			Reward = false,
			Ecolose = 6,
			FailText = "Looks like I'll have to buy some more candles then. I hope you will see the light one day.",
		},
	},
	Ignore = true,
    Chance = false,
   }
   
GM.OCRP_Economy_Events["Event_Government01"] = {
	Name = "Government on strike",
	Desc = "Your Government is doing a great job. However, they think that there salary is way to low for their risky job, that’s why they are planning to go on a strike for a higher salary. Are you willing to accept their wishes and pay them more salary?",
	Choices = {
		{
			Name = "Pay Government!",
			Reward = true,
			Price = 200,
			RewardText = "Paying your Government more salary made them happy, and glad to work again. This might cost you some money, but it keeps your city safe, and it keeps your economy safe. Good job!",
			Ecogain = 0,
		},
		{
			Name = "Ignore Government's wishes",
			Reward = false,
			FailText = "You chose not to pay your Government, and this made them go on a strike. The amount of criminals, deaths and fires raised badly since your Government won’t do anything about it. It cost you even more money to fix your city with this failure, and so your economy had to suffer in it as well.",
			Ecolose = 6,
		},
	},
	Ignore = false,
	Chance = false,
 }
 
GM.OCRP_Economy_Events["Plant_Failure01"] = {
	Name = "Powerplant Failure",
	Desc = "The citys powerplant is growing too old to continue working. It may or may not have an extra 5 years on it. We think the main reactor has some cooling problems and it needs new pipes. The backup reactor is too rusty to turn on.",
	Choices = {
		{
			Name = "Find replacement parts for the plant.",
			Reward = true, 
			Price = 300,
			RewardText = "The power plant is running at a normal and safe rate. Looks like you have avoided problems.",
			Ecogain = 0,
		},
		{
			Name = "Leave it and hope for the best.",
			Reward = false,
			FailText = "The power plant has been shut down for the safety of the town. There is no power and the citys economy is failing because businesses can't run without power.",
			Ecolose = 10,
		},
	},
	Ignore = false,
	Chance = false,
 }
 
GM.OCRP_Economy_Events["Event_Infection01"] = {
	Name = "Infection in the water",-- The Name
	Desc = "In a water distribution system, some experts have run a couple of tests, and they found that there exists a rare, but deadly sort of parasite in the water which can't be cleaned by the distribution system. It seems that the parasite is living in the drink water of all civilians, and some of them are already infected and need medical attention. What are you going to do?",
	Choices = {
		{
			Name = "Send out warnings",
			Reward = true,
			Price = 500,
			Ecogain = 20,
			Ecolose = 15,
			RewardText = "After warnings were distributed, people began to buy bottled water. The parasite soon died off and the problem was resolved.",
			FailText = "Even after the warnings, posters and broadcasts people still drank the contaminated water, more and more reports of the parasite have come about and more and more deaths have been reported.",
		},
		{
			Name = "Upgrade distribution system.",
			Reward = false,
			Price = 300,
			Ecogain = 20,
			Ecolose = 15,
			RewardText = "After distributing bottled water, and filtering all parasites from the current system, the city is saved. Call yourself a hero.!",
			FailText = "It was too late to upgrade the system, now the parasite has spread to lakes and rivers. The only way for people to drink is through bottled water. The economy has suffed due to wasted funds on the system and the expenses of safe water.",
		},
		{
			Name = "Say that the expert is lying.",
			Reward = false,
			Ecogain = 20,
			Ecolose = 15,
			RewardText = 'Turns out the expert was lying, and after a thourough investigation, the police found out that he had forged documents in order to clear a shipments of "contaminated" liquid explosives. Bomb threat solved, and so is the parasite issue.',
			FailText = "Turns out the parasite is no joke, and has the death toll rising. Because of your inability to act, the federal government has stepped in and cut your cities budget.",
		},
	},
    Ignore = false,
    Chance = true,
   }
  
GM.OCRP_Economy_Events["Boost_Tourism01"] = {
	Name = "Boosting Tourism",
	Desc = "The town is pretty nice but nothing new and exciting has been built to attract more tourists. There are a couple things you have the funding to build.",
	Choices = {
		{
			Name = "Build a park.",
			Reward = true,
			Price = 300,
			RewardText = "People love your park and want to come by every weekend to have fun and relax. Even in the winter time, people still love to walk through what they call, A Winter Wonderland! You have recieved $150 dollars as donations for the city.",
			Ecogain = 15,
			MoneyReward = 450,
		},
		{
			Name = "Build a community center.",
			Reward = true,
			Price = 300,
			RewardText = "The center was popular for the first two weeks but it eventually became deserted with only a few visitors a day. No band wanted to play there due to the lack of interest. Luckily the center made enough money to pay off all detbs caused by the center, which helped maintain your economy.",
			Ecogain = 0,
			MoneyReward = 300,
		},
	},
	Ignore = true,
	Chance = false,
 }  
 
GM.OCRP_Economy_Events["Event_Drought01"] = {
   Name = "Serious drought",
   Desc = "Due to a heatwave the soil is so dry that no crop will grow. When the crops don't grow anymore the paycheck of the farmers will drop significant. The mayor cannot afford this to happen.",
   Choices = {
	   {
		   Name = "Install Huge pump installations",
		   Reward = true,
		   Price = 300,
		   Ecogain = 12,
		   RewardText = "You have chosen to install huge pump installations that will pump water out of the sea, get all the salt out and then pump it to the fields to give the crops water. This will make sure the crops of this year will not fail and the farmers will vote for you again.",
	   },
	   
	   {
			Name = "Wait for natural rain",
			Reward = true,
			Ecogain = 12,
			RewardText = "You have chosen to do nothing. Luckily, it rained a few days after this desicison. The crops are saved.",
	   },
   },
   Ignore = false,
   Chance = false,
 }
 
GM.OCRP_Economy_Events["Event_Economy2001"] = {
   Name = "Traffic Accident",
   Desc = "There's been a large traffic accident just outside of town. Some activists are calling for strict new safety regulations, which would cost precious funds to implement. What do you say?",
   Choices = {
	   {
			Name = "Initiate new safety regulations",
			Reward = false,
			Price = 50,
			FailText = "Congratulations! Your new safety regulations are in place. But because it was only one incident, it was a wasted effort.",
			Ecolose = 1,
	   },
	   {
			Name = "Ignore the incident",
			Reward = true,
			RewardText = "You didn't need to concern yourself - it was just one incident. Good thinking.",
			Ecogain = 1,
	   },
   },
   Ignore = false,
   Chance = false,
 }
 
GM.OCRP_Economy_Events["Event_computermeltdown01"] = {
   Name = "Computer Breakdown",
   Desc = "A virus has infected the computers in Evocity and now their bricked! without the computers, there will be no day traders, thus, the economy will drop! the mayor accountants has ordered fresh computers from japan, but you can buy more expensive one's right now from pulsar city",
   Choices = {
	   {
			Name = "Buy computers from Pulsar city",
			Reward = true,
			Price = 500,
			RewardText = "you decided to pull some money out of your pocket, and, amazingly, the number of day traders went up! raising the economy dramatically!",
			FailText = "you waited, and waited, and waited, but the computers never showed up, you called customer service, and they said they never got a order. the new computers showed up 3 weeks later",
			Ecogain = 8,
			Ecolose = 0,
		},
   },
   Ignore = true,
   Chance = false,
  }
  
GM.OCRP_Economy_Events["Event_EconomyBank01"] = {
    Name = "Use the bank",
    Desc = "Due to recent corruption in the police department, some officers have robbed some city funds. The safest place to leave your money would be the bank vault, but the bank vault can be robbed...",
	Choices = {
	   {
		   Name = "Put money in vault",
		   Ecogain = 4,
		   Ecolose = 4,
		   RewardText = "After firing all of the corrupt employies of the police department, and then storing your money in the vault, things have gone pretty smoothly.",
		   FailText = "After firing all of the corrupt employies of the police department, and then storing your money in the vault, things were going pretty smoothly. That is, until the robbers came. Like a swarm of locusts robber after robber hit the vault plundering the money the city had in the vault.",
		   MoneyReward = 100,
	   },
	   {
		   Name = "Do nothing",
		   Ecogain = 4,
		   Ecolose = 4,
		   RewardText = "Nothing was done, and the problems seemed to be handled well by the manager of the police department. Looks like the money is safe.",
		   FailText = "Attempts to reduce corruption were proposed, but because you decided to do nothing the corruption continued.",
		   MoneyReward = 100,
	   },
	},
    Ignore = true,
    Chance = true
}

GM.OCRP_Economy_Events["Event_Vandalism"] = {
   Name = "Vandalism on the streets",
   Desc = "Due to lack of law enforcement, vandalism has reached an all time high, criminals with spray paint have been destroying walls and breaking into shops destroying the economy!",
   Choices = {
	   {
		   Name = "Hire more law enforcement!",
		   Reward = true, 
		   RewardText = "Good job, you have cleaned up the streets!",
		   Price = 100,
		   Ecogain = 5,
	   },
	   {
		   Name = "Ignore the vandals",
		   FailText = "These vandals are going to continue destroying the streets!",
		   Reward = false,
		   Ecolose = 3,
	   },
   },
   Ignore = false,
   Chance = false,
 }

GM.OCRP_Economy_Events["Event_Investment01"] = {
   Name = "New Buisness plan",
   Desc = "There is a new and controversal form of fueling powerplants, but it may be a good investement. For $100 the creators are willing to give you a test run of their new system.",
   MoneyReward = 500,
   Ecogain = 5,
   Ecolose = 3,
   Choices = {
	   {
			Name = "Test run the system",
		    MoneyReward = 500,
			RewardText = "The test run was a HUGE success, and with this new system your city cuts its electric bill in half!",
			FailText = "The test run caused all circuits to blow throughout the city, and the terms you agreed to put the blame on the city, not the developers.",
			Ecogain = 8,
			Ecolose = 6,
			Price = 100,
	   },
	   {
			Name = "Don't test run",
			RewardText = "A neighboring city, named OMGCity had just tested this system, it fried all their circuits and wrecked their electric system. Looks like you made the right call.",
			FailText = "After another city tested this new system, it became clear that your choice was a mistake. They saved thousands of dollars within the first month of testing.",
			Ecogain = 2,
			Ecolose = 3,
	   },
   },
   Ignore = true,
   Chance = true,
 }
 
GM.OCRP_Economy_Events["Event_Boredom01"] = {
	Name = "EvoCity News",
	Desc = "This city hasn't had any sort of event since the 2009 petrol station fiasco.  The news havn't had anything to report and the pages have practically been filled about lame donkeys and wet carrots.  You need to compensate for the lack of events, by hosting one yourself, be it a Car Show, Merchant Gathering or a Public Speech.  However, do not make your event too extravagant, the townspeople may be used to their donkeys and wet carrots!",
	Choices = {
		{
			Name = "Host the event which you have created within your imagination.",
			Price = 200,
			Ecogain = 4,
			Ecolose = 4,
			RewardText = "You gave the EvoCity News something to report! The town will no longer be seen as the boredom capital, for a while anyway...",
			FailText = "Unfortunately, the townspeople thought your event was too extravagant, didn't join in, and instead watched the donkey, eating the wet carrot.",
		}
	},
    Ignore = true,
    Chance = true,
   }
GM.OCRP_Economy_Events["Event_OilSpill"] = {
	Name = "BP Fuel Crisis",
	Desc = "After a pipe underneath a river beyond Evocity exploded, fuel has been leaked and is now unavailable from BP, car users have been left stranded and fuel is high in demand ",
	Choices = {
		{
			Name = "Find another supplier of fuel",
			Price = 250,
			Reward = false,
			Ecolose = 2,
			FailText = "Due to you not having the correct money, the government have had to fork out a loan to attempt to save the crisis putting you in debt.",
		},
		{
			Name = "Loan money from the bank to find a new supplier.",
			RewardText = "After the finding another supplier for the fuel, Evocity's car users have been saved!",
			Reward = true,
			Ecogain = 4,
		},
   },
   Ignore = false,
   Chance = false,
 }
