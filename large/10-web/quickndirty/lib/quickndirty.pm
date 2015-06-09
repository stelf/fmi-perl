package quickndirty;
use Dancer ':syntax';

our $VERSION = '0.1';

get '/' => sub {
    template 'index';
};

get '/:num1/:num2' => sub {
	my $res = int param('num1') + int param('num2');

	template 'calc', { res => $res };
};

true;
