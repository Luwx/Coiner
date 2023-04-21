import 'package:flutter/material.dart';
import 'package:coiner_app/data/models/coin.dart';

class CoinCard extends StatefulWidget {
  final Coin coin;
  final VoidCallback onFavoriteToggle;

  const CoinCard({
    super.key,
    required this.coin,
    required this.onFavoriteToggle,
  });

  @override
  State<CoinCard> createState() => _CoinCardState();
}

class _CoinCardState extends State<CoinCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.coin.name ?? '',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(
                    Icons.favorite,
                    color: widget.coin.isFavorite ? Colors.red : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      widget.coin.isFavorite = !widget.coin.isFavorite;
                    });
                    widget.onFavoriteToggle();
                  },
                ),
              ],
            ),
            Text(
              widget.coin.symbol ?? '',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Text('Supply: ${widget.coin.supply ?? ''}'),
            Text('Rank: ${widget.coin.rank ?? ''}'),
          ],
        ),
      ),
    );
  }
}
