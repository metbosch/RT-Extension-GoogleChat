use inc::Module::Install;

RTx     'RT-Extension-GoogleChat';
license 'MIT';
repository 'https://github.com/metbosch/RT-Extension-GoogleChat';

requires_rt '5.0.0';
rt_too_new '6.0.0';

sign;
WriteAll;
