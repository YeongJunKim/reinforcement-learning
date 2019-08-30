clf
clc
clear all

%% init area
data.ACTION_HIT = 0;
data.ACTION_STAND = 1;
data.ACTIONS = [data.ACTION_HIT, data.ACTION_STAND];

data.POLICY_PLAYER = zeros(22);

for i = 12:1:20
   data.POLICY_PLAYER(i) = data.ACTION_HIT;
end
data.POLICY_PLAYER(20) = data.ACTION_STAND;
data.POLICY_PLAYER(21) = data.ACTION_STAND;

%policy for dealer
data.POLICY_DEALER = zeros(22,1);
for i = 12:17
   data.POLICY_DEALER(i) = data.ACTION_HIT;
end
for i = 17:22
    data.POLICY_DEALER(i) = data.ACTION_STAND;
end

%% end init
%% main code
data


behavior_policy_player(0,0,0,data);
get_card();

%% function form of target policy of player
function ps = target_policy_player(usable_ace_player, player_sum, dealer_card, data)
    ps = data.POLICY_PLAYER(player_sum); 
end

%% function form of behavior policy of player
function action = behavior_policy_player(usable_ace_player, player_sum, dealer_card, data)
    y = datasample([1,0.5], 1);
    if y == 1
        action = data.ACTION_STAND;
    else
        action = data.ACTION_HIT;
    end
end
%% function form of get a new card
function card = get_card()
    y = datasample([1:1:14], 1);
    card = min(y, 10);
end
%% function form of get the value of a card (11 for ace)
function cd = card_value(card_id)
    if card_id == 1
        cd = 11;
    else
        cd = card_id;
    end
end
%% play a game
%% @policy_player : specify policy for player
%% @inital_state : [whether player has a usable Ace, sum of player's cards, one card of dealer]
%% @inital_action : the initial action
function [state, reward, player_trajectory] = play(policy_player, inital_state, initial_action, data)
    %player status
    %sum of player
    player_sum = 0;
    %trajectory of player
    player_trajectory = zeros(1,1);
    %whether player uses Ace as 11
    usable_ace_player = -1;
    %dealer status
    dealer_card1 = 0;
    dealer_card2 = 0;
    usable_ace_dealer = -1;
    
    if initial_state == -1
       %generate a random inital state
       while(true)
           %if sum of player is less than 12, always hit
           card = get_gard()
           player_sum = player_sum + card_value(card)
           % if the player's sum is larger than 21, he may hold one or two
           % aces.
           if player_sum > 21
               % assert player_sum == 22
               player_sum = player_sum - 10;
           else
               if card == 1
                   usable_ace_player = 1;
               else
                   usable_ace_player = -1;
               end
               
           end
       end
       % initialize cards of dealer, suppose dealer will show the first
       % card he gets
       dealer_card1 = get_card();
       dealer_card2 = get_card();
    else
        % use speicified initial state
        usable_ace_player = initial_state;
        player_sum = initial_state;
        dealer_card1 = initial_state;
        dealer_card2 = get_card();
    end
    % initial state of the game
    state = [usable_ace_player, player_sum, dealer_card];
    
    % initial dealer's sum
    dealer_sum = card_value(dealer_card1) + card_value(dealer_card2);
    if dealer_card1 == 1 || dealer_card2 == 1
        usable_ace_dealer = 1;
    end
    % if the dealer's sum is larger than 21, he must hold two aces.
    if dealer_sum > 21
        % assert dealer_sum == 22
        dealer_sum = dealer_sum - 10;
    end
    
    % game start
    while(true)
       if initial_action ~= -1
           action = initial_action
           initial_action = -1;
       else
           action = policy_player(
       end
    end
    
end


