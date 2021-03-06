# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

use Test::More;

use lib sub {
    die "No Cpanel" if $_[1] =~ m{Cpanel/JSON/XS.pm$};
    return undef;
};

use Search::Elasticsearch;

my $s = Search::Elasticsearch->new()->transport->serializer->JSON;

SKIP: {
    skip 'JSON::XS not installed' => 1
        unless eval { require JSON::XS; 1 };

    isa_ok $s, "JSON::XS", 'JSON::XS';
}

done_testing;

