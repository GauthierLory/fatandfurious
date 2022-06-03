<?php

$value = $_GET['value'] ?? '';

$curl = curl_init();

curl_setopt_array($curl, array(
    CURLOPT_URL => 'https://api.tvmaze.com/search/shows?q=' . $value,
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_ENCODING => '',
    CURLOPT_MAXREDIRS => 10,
    CURLOPT_TIMEOUT => 0,
    CURLOPT_FOLLOWLOCATION => true,
    CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
    CURLOPT_CUSTOMREQUEST => 'GET',
));

$response = curl_exec($curl);

curl_close($curl);

$movies = json_decode($response);

foreach ($movies as $movie) {

    echo $movie->show->name . "<br>";
}

function search(string $needed, array $data): array
{
    foreach ($data as $movie) {
        if (strpos($movie->show->name, $needed) !== false) {
            $result[] = $movie->show->name;
        }
    }
    return $result;
}

?>

<p>Search</p>

<input type="text" id="textValue">
<input type="button" value="Valider" id="validButton">

<p class="validSearch"></p>



<script type="text/javascript">

window.addEventListener('load', function() {
    console.log('All assets are loaded')

    document.getElementById('validButton').addEventListener('click', function() {
        let value = document.getElementById('textValue').value

        fetch('https://api.tvmaze.com/search/shows?q=' + value)
        .then(function(response) {
            console.log(response);
            // (response.body).for(element => {
            // });
            for (const [key, value] of Object.entries(response.body)) {
                console.log(`${key}: ${value}`);
                console.log('toto')
                // console.log(element.show.name)
            }
        })
        
    })

})

</script>