$REQUIRED = [] unless defined? $REQUIRED
$REQUIRED << __FILE__.sub(/.*(require_all_test)/, '\1')
