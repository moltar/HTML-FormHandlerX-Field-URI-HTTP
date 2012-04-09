use Test::More;

BEGIN { use_ok('HTML::FormHandlerX::Field::URI::HTTP'); }

sub _pass {
    my ($field, $uri) = @_;
    $field->_set_input($uri);
    $field->validate_field;
    ok ! $field->has_errors, "Pass: $uri";
}

sub _fail {
    my ($field, $uri) = @_;
    $field->_set_input($uri);
    $field->validate_field;
    ok $field->has_errors, "Fail: $uri";
}

## defaults
my $uri = HTML::FormHandlerX::Field::URI::HTTP->new(name => 'uri');

_pass($uri, 'http://example.com');
_pass($uri, 'HTTP://example.com');

_fail($uri, 'abracadabra');
_fail($uri, 1);

## schema HTTP only
$uri = HTML::FormHandlerX::Field::URI::HTTP->new(name => 'uri', scheme => qr/http/i);
_pass($uri, 'http://example.com');
_fail($uri, 'https://example.com');

## schema HTTPS only
$uri = HTML::FormHandlerX::Field::URI::HTTP->new(name => 'uri', scheme => qr/https/i);
_pass($uri, 'https://example.com');
_fail($uri, 'http://example.com');

## value is inflated
$uri = HTML::FormHandlerX::Field::URI::HTTP->new(name => 'uri');
_pass($uri, 'http://example.com');
is $uri->value, 'http://example.com', 'value is set';
isa_ok $uri->value, 'URI';

done_testing;
# eof
