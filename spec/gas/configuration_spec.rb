require './spec/spec_helper'

require './lib/gas'

describe Gas::Configuration do
  it 'should be able to parse users from config format' do
    name = 'Fredrik Wallgren'
    email = 'fredrik.wallgren@gmail.com'
    nickname = 'walle'
    config = "[#{nickname}]\n  name = #{name}\n  email = #{email}\n\n[user2]\n  name = foo\n  email = bar"
    config = Gas::Configuration.parse config
    config.users.count.should == 2
    config.users[0].name.should == name
    config.users[0].email.should == email
    config.users[0].nickname.should == nickname
  end

  it 'should be able to get current user from gitconfig' do
    name = 'Fredrik Wallgren'
    email = 'fredrik.wallgren@gmail.com'
    gitconfig = "[other stuff]\n  foo = bar\n\n[user]\n  name = #{name}\n  email = #{email}\n\n[foo]\n  bar = foo"
    user = Gas::Configuration.current_user gitconfig
    user.name.should == name
    user.email.should == email
  end

  it 'should output the users in the correct format' do
    user1 = Gas::User.new 'Fredrik Wallgren', 'fredrik.wallgren@gmail.com', 'walle'
    user2 = Gas::User.new 'foo', 'bar', 'user2'
    users = [user1, user2]
    config = Gas::Configuration.new users
    config.to_s.should == "[walle]\n  name = Fredrik Wallgren\n  email = fredrik.wallgren@gmail.com\n[user2]\n  name = foo\n  email = bar"
  end

  it 'should be able to tell if a nickname exists' do
    user1 = Gas::User.new 'Fredrik Wallgren', 'fredrik.wallgren@gmail.com', 'walle'
    user2 = Gas::User.new 'foo', 'bar', 'user2'
    users = [user1, user2]
    config = Gas::Configuration.new users
    config.exists?('walle').should be_true
    config.exists?('foo').should be_false
    config.exists?('user2').should be_true
  end

  it 'should be able to get a user from a nickname' do
    user1 = Gas::User.new 'Fredrik Wallgren', 'fredrik.wallgren@gmail.com', 'walle'
    user2 = Gas::User.new 'foo', 'bar', 'user2'
    users = [user1, user2]
    config = Gas::Configuration.new users
    config.get('walle').should == user1
    config.get('user2').should == user2
    config['walle'].should == user1
    config['user2'].should == user2
    config[:walle].should == user1
    config[:user2].should == user2
  end
end

